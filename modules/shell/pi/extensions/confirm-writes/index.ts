/**
 * Confirm Writes Extension
 *
 * Prompts for confirmation before any edit or write tool call,
 * showing a diff preview with intra-line change highlighting.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { DynamicBorder } from "@mariozechner/pi-coding-agent";
import {
  Container,
  SelectList,
  Text,
  matchesKey,
  type Component,
  type SelectItem,
} from "@mariozechner/pi-tui";
import { readFile, writeFile, mkdtemp, rm } from "node:fs/promises";
import { resolve, join } from "node:path";
import { execFileSync } from "node:child_process";
import { tmpdir } from "node:os";
import { renderEditDiffResult } from "./vendor/diff-renderer.js";
import { DEFAULT_TOOL_DISPLAY_CONFIG } from "./vendor/types.js";

/**
 * Maximum number of diff lines shown in the collapsed (inline) view before
 * truncation. Tab to expand shows all lines in a scrollable fullscreen view.
 */
const COLLAPSED_LINES = 20;

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

/**
 * Produce a raw unified diff (from system `diff -u`) for the file change.
 */
async function buildPatch(filePath: string, original: string, newContent: string): Promise<string> {
  const dir = await mkdtemp(join(tmpdir(), "confirm-writes-"));
  const oldFile = join(dir, "old");
  const newFile = join(dir, "new");
  try {
    await writeFile(oldFile, original);
    await writeFile(newFile, newContent);
    const result = execFileSync("diff", [
      "-u", "--label", `a/${filePath}`, "--label", `b/${filePath}`, oldFile, newFile,
    ]);
    return result.toString();
  } catch (e: any) {
    return e.stdout?.toString() ?? "";
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
}

type DialogOutcome = "yes" | "no" | "toggle";

async function showDiffConfirm(
  ctx: Parameters<Parameters<ExtensionAPI["on"]>[1]>[1],
  toolName: string,
  filePath: string,
  patch: string,
): Promise<boolean> {
  // Persist view state across overlay/non-overlay reopens (tab toggles).
  const state = { expanded: false, scroll: 0 };
  while (true) {
    const outcome = await openDialog(ctx, toolName, filePath, patch, state);
    if (outcome === "yes") return true;
    if (outcome === "no") return false;
    // toggle: flip mode and reopen
    state.expanded = !state.expanded;
    state.scroll = 0;
  }
}

function openDialog(
  ctx: Parameters<Parameters<ExtensionAPI["on"]>[1]>[1],
  toolName: string,
  filePath: string,
  patch: string,
  state: { expanded: boolean; scroll: number },
): Promise<DialogOutcome> {
  const useOverlay = state.expanded;
  return ctx.ui.custom<DialogOutcome>(
    (tui, theme, _kb, done) => {
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
    selectList.onSelect = (item: SelectItem) => {
      done(item.value === "yes" ? "yes" : "no");
    };
    selectList.onCancel = () => {
      done("no");
    };

    // Render the diff with the vendored pi-tool-display renderer (opencode-style).
    // Colors come from the renderer; we only disable its full-width container
    // background (pi's toolSuccessBg green tint bleeds into every row via
    // resolveContainerBackgroundAnsi) by hiding those bg slots from it, and
    // strip header chrome we don't want (frame borders, file meta, hunk headers).
    const diffTheme: any = new Proxy(theme, {
      get(target: any, prop: string | symbol) {
        if (prop === "getBgAnsi") {
          return (color: string) => {
            if (
              color === "toolSuccessBg" ||
              color === "toolPendingBg" ||
              color === "toolErrorBg" ||
              color === "userMessageBg"
            ) {
              return "";
            }
            return target.getBgAnsi(color);
          };
        }
        const v = target[prop];
        return typeof v === "function" ? v.bind(target) : v;
      },
    });
    const diffComponent = renderEditDiffResult(
      { diff: patch },
      { expanded: true, filePath },
      { ...DEFAULT_TOOL_DISPLAY_CONFIG, diffInlineEmphasis: false },
      diffTheme,
      "",
    );
    const stripAnsi = (s: string) => s.replace(/\x1b\[[0-9;]*m/g, "");
    function stripChrome(lines: string[]): string[] {
      return lines.filter((line) => {
        const bare = stripAnsi(line).trim();
        if (bare.startsWith("--- ") || bare.startsWith("+++ ")) return false;
        if (bare.startsWith("@@")) return false;
        // if (bare.length > 0 && /^[─━═]+$/.test(bare)) return false;
        return true;
      });
    }

    let cachedAllLines: string[] = [];
    let cachedAllWidth = -1;
    function getAllLines(contentCols: number): string[] {
      // Vendor (pi-tool-display's renderEditDiffResult) emits each row at
      // exactly `contentCols` wide with the row background already painted
      // across the full width and SGR state balanced per row. We use those
      // lines verbatim downstream — no re-truncate, no re-pad, no reset
      // injection — because any of those would inject a stray `\x1b[0m`
      // mid-row and break the vendor's carefully stabilized background.
      if (cachedAllWidth !== contentCols) {
        cachedAllLines = stripChrome(diffComponent.render(contentCols));
        cachedAllWidth = contentCols;
      }
      return cachedAllLines;
    }

    let expanded = state.expanded;
    let scroll = state.scroll;

    /**
     * The vendor diff renderer (renderEditDiffResult) already emits each
     * line fully padded to the requested width and wrapped in its own row
     * background. Its `stabilizeBackgroundResets` pass keeps the row bg
     * alive across inline fg resets, so the output is already a
     * self-contained, full-width, bg-correct row. We pass it through
     * verbatim — no customBgFn, no leading `\x1b[0m`, no post-processing.
     */
    const diffText = new Text("", 0, 0);
    const stickyHead = new Text("", 0, 0);
    const hintText = new Text("", 1, 0);

    /**
     * Scrolling viewport for the diff body with a scrollbar column on the
     * right. State lives outside the component (captured via the getter
     * callbacks) so scroll/resize handlers in the parent just update the
     * closure vars and request a render — the component stays a pure
     * function of its inputs.
     *
     * The parent pre-truncates body lines via the vendor renderer at exactly
     * contentCols (= width - 1). Each vendor line is already a full-width,
     * bg-painted, SGR-balanced row, so we emit it verbatim and just append
     * the scrollbar glyph in the reserved last column.
     *
     * For empty slots (when the diff is shorter than visibleRows), we emit a
     * plain space-padded line so the overlay still fully covers chrome.
     */
    class DiffViewport implements Component {
      private getLines: () => string[];
      private getScroll: () => number;
      private getVisibleRows: () => number;
      constructor(
        getLines: () => string[],
        getScroll: () => number,
        getVisibleRows: () => number,
      ) {
        this.getLines = getLines;
        this.getScroll = getScroll;
        this.getVisibleRows = getVisibleRows;
      }
      invalidate(): void {}
      render(width: number): string[] {
        const visibleRows = this.getVisibleRows();
        const bodyLines = this.getLines();
        const total = bodyLines.length;
        const needBar = total > visibleRows;
        // Reserve the final column for the scrollbar (or an empty spacer col
        // so rows align with the sticky head above). Floor at 1 for narrow
        // terminals.
        const contentCols = Math.max(1, width - 1);

        let scrollPos = this.getScroll();
        const maxScroll = Math.max(0, total - visibleRows);
        if (scrollPos > maxScroll) scrollPos = maxScroll;
        if (scrollPos < 0) scrollPos = 0;

        // Scrollbar thumb range (only meaningful when needBar).
        let thumbStart = 0;
        let thumbEnd = 0;
        if (needBar) {
          const thumbSize = Math.max(1, Math.floor((visibleRows * visibleRows) / total));
          const maxScrollForBar = Math.max(1, total - visibleRows);
          thumbStart = Math.floor((scrollPos / maxScrollForBar) * (visibleRows - thumbSize));
          thumbEnd = thumbStart + thumbSize;
        }

        const slice = bodyLines.slice(scrollPos, scrollPos + visibleRows);
        const emptyPad = " ".repeat(contentCols);
        const out: string[] = [];
        for (let i = 0; i < visibleRows; i++) {
          const raw = slice[i];
          // Vendor lines are already exactly contentCols wide and bg-painted.
          // Empty slots (past end of diff) use a plain padded line.
          const body = raw !== undefined ? raw : emptyPad;
          const bar = needBar
            ? (i >= thumbStart && i < thumbEnd
                ? theme.fg("accent", "█")
                : theme.fg("dim", "│"))
            : " ";
          // Vendor line owns its own bg/fg lifecycle (opens with rowBg,
          // keeps it alive across inline resets). Bar is appended after
          // the vendor's trailing state — intentionally unwrapped so we
          // add zero extra escape sequences to what vendor produced.
          out.push(`${body}${bar}`);
        }
        return out;
      }
    }

    // Derived state for the expanded viewport. Recomputed in refresh() so
    // DiffViewport stays a pure function of these values.
    let viewportVisibleRows = 0;
    let viewportBodyLines: string[] = [];
    const diffViewport = new DiffViewport(
      () => viewportBodyLines,
      () => scroll,
      () => viewportVisibleRows,
    );

    function computeCollapsedText(): string {
      const termCols = tui.terminal.columns ?? 80;
      const contentCols = Math.max(20, termCols);
      // Vendor renders at exactly contentCols and emits full-width, bg-painted
      // rows. We use them verbatim — no re-truncation (that would inject extra
      // `\x1b[0m` resets mid-line and break the vendor's row-bg invariants).
      const allLines = getAllLines(contentCols);
      const total = allLines.length;
      if (total <= COLLAPSED_LINES) return allLines.join("\n");
      const slice = allLines.slice(0, COLLAPSED_LINES);
      slice.push(theme.fg("dim", `   … ${total - COLLAPSED_LINES} more lines (tab to expand)`));
      return slice.join("\n");
    }

    function computeExpandedViewport(): void {
      const termCols = tui.terminal.columns ?? 80;
      const termRows = tui.terminal.rows ?? 40;
      // Expanded reserves 1 col for the scrollbar; content lives in termCols-1.
      const contentCols = Math.max(20, termCols - 1);
      const allLines = getAllLines(contentCols);
      // Sticky header: vendor emits `[summary, frame, ...body, frame]` (unified)
      // or `[summary, ...body]` (split). Keeping the first 2 rows pinned avoids
      // redrawing them on every scroll tick, shrinking TUI's diff range.
      const stickyTop = Math.min(2, allLines.length);
      const headLines = allLines.slice(0, stickyTop);
      const bodyLines = allLines.slice(stickyTop);
      // Chrome: title(1) + titleBorder(1) + hint(1) + bottomBorder(1) = 4 rows
      const visibleRows = Math.max(10, termRows - 4 - stickyTop);

      viewportVisibleRows = visibleRows;
      // Verbatim vendor lines — DiffViewport composes each row as
      // `${vendorLine}${barChar}` with no further truncation/padding.
      viewportBodyLines = bodyLines;

      // Clamp scroll against the new body length.
      const maxScroll = Math.max(0, viewportBodyLines.length - visibleRows);
      if (scroll > maxScroll) scroll = maxScroll;
      if (scroll < 0) scroll = 0;

      // Sticky head: vendor lines verbatim, joined with newlines.
      stickyHead.setText(headLines.join("\n"));
    }

    function updateHint() {
      const termCols = tui.terminal.columns ?? 80;
      if (expanded) {
        const maxScroll = Math.max(0, viewportBodyLines.length - viewportVisibleRows);
        hintText.setText(theme.fg("dim", `tab collapse • j/k C-d/C-u g/G (${scroll}/${maxScroll}) • esc cancel`));
      } else {
        const contentCols = Math.max(20, termCols);
        const totalLines = getAllLines(contentCols).length;
        if (totalLines > COLLAPSED_LINES) {
          hintText.setText(theme.fg("dim", "↑↓ navigate • enter select • esc cancel • tab expand diff"));
        } else {
          hintText.setText(theme.fg("dim", "↑↓ navigate • enter select • esc cancel"));
        }
      }
    }

    const container = new Container();
    const titleText = new Text(
      theme.fg("accent", theme.bold(`${toolName}: `)) + theme.fg("text", filePath),
      1, 0,
    );
    const titleBorder = new DynamicBorder((s: string) => theme.fg("accent", s));
    const spacer = new Text("", 0, 0);
    const bottomBorder = new DynamicBorder((s: string) => theme.fg("accent", s));

    function rebuildChildren() {
      container.clear();
      container.addChild(titleText);
      container.addChild(titleBorder);
      if (expanded) {
        // Expanded: sticky head + scrolling viewport component.
        container.addChild(stickyHead);
        container.addChild(diffViewport);
      } else {
        container.addChild(diffText);
        container.addChild(spacer);
        container.addChild(selectList);
      }
      container.addChild(hintText);
      container.addChild(bottomBorder);
    }

    let lastExpanded: boolean | null = null;
    function refresh() {
      if (expanded) {
        computeExpandedViewport();
      } else {
        diffText.setText(computeCollapsedText());
      }
      updateHint();
      if (lastExpanded !== expanded) {
        rebuildChildren();
        lastExpanded = expanded;
      }
      tui.requestRender();
    }

    refresh();

    let lastRenderWidth = -1;
    return {
      render(w: number): string[] {
        // Re-derive diff text on width change (terminal resize) so the vendor
        // auto-mode can flip between unified/split and our wrap/truncate updates.
        if (w !== lastRenderWidth) {
          lastRenderWidth = w;
          refresh();
        }
        const lines = container.render(w);
        if (expanded) {
          // Fill to full terminal height so overlay fully covers underlying chrome
          const termRows = tui.terminal.rows ?? 40;
          while (lines.length < termRows) lines.push("");
          return lines.slice(0, termRows);
        }
        return lines;
      },
      invalidate() { container.invalidate(); },
      handleInput(data: string) {
        // Tab toggles expanded — reopen dialog in the other mode.
        if (matchesKey(data, "tab")) {
          done("toggle");
          return;
        }
        if (expanded) {
          // Use the viewport state computed by computeExpandedViewport() as
          // the single source of truth for scroll math — no duplicated
          // termRows/stickyTop arithmetic here.
          const visibleRows = viewportVisibleRows;
          const bodyCount = viewportBodyLines.length;
          const halfPage = Math.max(1, Math.floor(visibleRows / 2));
          if (matchesKey(data, "down") || data === "j") { scroll += 1; refresh(); return; }
          if (matchesKey(data, "up") || data === "k") { scroll -= 1; refresh(); return; }
          if (matchesKey(data, "ctrl+d")) { scroll += halfPage; refresh(); return; }
          if (matchesKey(data, "ctrl+u")) { scroll -= halfPage; refresh(); return; }
          if (matchesKey(data, "pageDown") || data === " ") { scroll += visibleRows; refresh(); return; }
          if (matchesKey(data, "pageUp") || data === "b") { scroll -= visibleRows; refresh(); return; }
          if (matchesKey(data, "home") || data === "g") { scroll = 0; refresh(); return; }
          if (matchesKey(data, "end") || data === "G") {
            scroll = Math.max(0, bodyCount - visibleRows);
            refresh();
            return;
          }
          // Still allow esc to cancel while expanded
          if (matchesKey(data, "escape")) { selectList.handleInput(data); return; }
          // Swallow everything else (don't route to hidden select list)
          return;
        }
        // Collapsed: map j/k to arrow keys for vim-style select list nav
        if (data === "j") { selectList.handleInput("\x1b[B"); tui.requestRender(); return; }
        if (data === "k") { selectList.handleInput("\x1b[A"); tui.requestRender(); return; }
        selectList.handleInput(data);
        tui.requestRender();
      },
    };
    },
    useOverlay
      ? {
          overlay: true,
          // Expanded mode: full-screen overlay covers the spinner and chrome.
          overlayOptions: () => {
            const cols = (process.stdout.columns as number | undefined) ?? 80;
            const rows = (process.stdout.rows as number | undefined) ?? 40;
            return { anchor: "bottom-left" as const, width: cols, maxHeight: rows };
          },
        }
      : {
          // Collapsed mode: attach to editor container (non-overlay) so the
          // dialog sits below the chat history without covering messages.
          overlay: false,
        },
  );
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

    const patch = await buildPatch(filePath, original, newContent);
    const result = await showDiffConfirm(ctx, event.toolName, filePath, patch);

    if (!result) {
      return { block: true, reason: "Blocked by user" };
    }
  });
}
