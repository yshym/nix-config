/**
 * Confirm Writes Extension
 *
 * Prompts for confirmation before any edit or write tool call,
 * showing a diff preview with intra-line change highlighting.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { DynamicBorder, highlightCode, getLanguageFromPath } from "@mariozechner/pi-coding-agent";
import { Container, SelectList, Text, type SelectItem, visibleWidth, wrapTextWithAnsi } from "@mariozechner/pi-tui";
import { readFile, writeFile, mkdtemp, rm } from "node:fs/promises";
import { resolve, join } from "node:path";
import { execFileSync } from "node:child_process";
import { tmpdir } from "node:os";

type Edit = {
  oldText: string;
  newText: string;
};

function applyEdits(original: string, edits: Edit[]): string {
  let result = original;
  for (const edit of edits) {
    result = result.replace(edit.oldText, edit.newText);
  }
  return result;
}

async function unifiedDiff(filePath: string, oldStr: string, newStr: string): Promise<string> {
  const dir = await mkdtemp(join(tmpdir(), "confirm-writes-"));
  const oldFile = join(dir, "old");
  const newFile = join(dir, "new");
  try {
    await writeFile(oldFile, oldStr);
    await writeFile(newFile, newStr);
    const result = execFileSync("diff", [
      "-u", "--label", `a/${filePath}`, "--label", `b/${filePath}`, oldFile, newFile,
    ]);
    return result.toString();
  } catch (e: any) {
    // diff exits 1 when files differ, which is normal
    if (e.stdout) return e.stdout.toString();
    return "";
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
}

type DiffLine = {
  type: "+" | "-" | " ";
  content: string;
};

async function buildDiffLines(filePath: string, original: string, newContent: string): Promise<DiffLine[]> {
  const patch = await unifiedDiff(filePath, original, newContent);
  return patch.split("\n")
    .filter((l) => !l.startsWith("---") && !l.startsWith("+++") && !l.startsWith("@@") && l !== "")
    .map((l): DiffLine => {
      if (l.startsWith("+")) return { type: "+", content: l.slice(1) };
      if (l.startsWith("-")) return { type: "-", content: l.slice(1) };
      return { type: " ", content: l.startsWith(" ") ? l.slice(1) : l };
    });
}

const FULL_RESET = "\x1b[0m";
const FG_RESET = "\x1b[39m";

function padBgLine(line: string, bg: string, width: number): string {
  const vis = visibleWidth(line);
  const pad = vis < width ? " ".repeat(width - vis) : "";
  return `${bg}${line}${pad}${FULL_RESET}`;
}

function styleDiffLines(diffLines: DiffLine[], filePath: string, theme: any, width: number): string[] {
  const lang = getLanguageFromPath(filePath);
  const highlighted = lang
    ? highlightCode(diffLines.map((l) => l.content).join("\n"), lang)
    : diffLines.map((l) => l.content);

  const bgAdded = theme.getBgAnsi("toolSuccessBg");
  const bgRemoved = theme.getBgAnsi("toolErrorBg");
  const fgAdded = theme.getFgAnsi("toolDiffAdded");
  const fgRemoved = theme.getFgAnsi("toolDiffRemoved");

  const result: string[] = [];
  for (let i = 0; i < diffLines.length; i++) {
    const line = diffLines[i];
    const code = highlighted[i] ?? line.content;

    if (line.type === " ") {
      result.push(` ${theme.fg("toolDiffContext", code)}`);
      continue;
    }

    const bg = line.type === "+" ? bgAdded : bgRemoved;
    const fg = line.type === "+" ? fgAdded : fgRemoved;
    const sign = line.type === "+" ? "+" : "-";
    const raw = `${fg}${sign}${FG_RESET}${code}`;

    // Pre-wrap then pad each wrapped segment to full width with background
    const wrapped = wrapTextWithAnsi(raw, width);
    for (const segment of wrapped) {
      result.push(padBgLine(segment, bg, width));
    }
  }
  return result;
}

function showDiffConfirm(
  ctx: Parameters<Parameters<ExtensionAPI["on"]>[1]>[1],
  toolName: string,
  filePath: string,
  diffLines: DiffLine[],
): Promise<boolean> {
  return ctx.ui.custom<boolean>((tui, theme, _kb, done) => {
    const selectList = new SelectList(
      [
        { value: "yes", label: "Yes, apply" },
        { value: "no", label: "No, block" },
      ] as SelectItem[],
      2,
      {
        selectedPrefix: (t: string) => theme.fg("accent", t),
        selectedText: (t: string) => theme.fg("accent", t),
        description: (t: string) => theme.fg("muted", t),
        scrollInfo: (t: string) => theme.fg("dim", t),
        noMatch: (t: string) => theme.fg("warning", t),
      },
    );
    selectList.onSelect = (item: SelectItem) => done(item.value === "yes");
    selectList.onCancel = () => done(false);

    let lastWidth = 0;
    let container = new Container();

    function rebuild(w: number) {
      container = new Container();
      container.addChild(new DynamicBorder((s: string) => theme.fg("accent", s)));
      container.addChild(
        new Text(
          theme.fg("accent", theme.bold(`${toolName}: `)) + theme.fg("text", filePath),
          1, 0,
        ),
      );
      container.addChild(new Text("", 0, 0));
      const styledLines = styleDiffLines(diffLines, filePath, theme, w);
      for (const line of styledLines) {
        container.addChild(new Text(line, 0, 0));
      }
      container.addChild(new Text("", 0, 0));
      container.addChild(selectList);
      container.addChild(
        new Text(theme.fg("dim", "↑↓ navigate • enter select • esc cancel"), 1, 0),
      );
      container.addChild(new DynamicBorder((s: string) => theme.fg("accent", s)));
      lastWidth = w;
    }

    return {
      render(w: number): string[] {
        if (w !== lastWidth) rebuild(w);
        return container.render(w);
      },
      invalidate() { container.invalidate(); },
      handleInput(data: string) {
        selectList.handleInput(data);
        tui.requestRender();
      },
    };
  });
}

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName !== "edit" && event.toolName !== "write") return;
    if (!ctx.hasUI) return { block: true, reason: "Write blocked (no UI)" };

    const filePath = event.input.path as string;
    const absPath = resolve(ctx.cwd, filePath);

    let original = "";
    try {
      original = await readFile(absPath, "utf8");
    } catch {
      // New file
    }

    let newContent: string;
    if (event.toolName === "edit") {
      const edits = (event.input.edits as Edit[]) ?? [];
      newContent = applyEdits(original, edits);
    } else {
      newContent = event.input.content as string;
    }

    const diffLines = await buildDiffLines(filePath, original, newContent);
    const result = await showDiffConfirm(ctx, event.toolName, filePath, diffLines);

    if (!result) {
      return { block: true, reason: "Blocked by user" };
    }
  });
}
