/**
 * permission-gates extension
 *
 * Prompts the user to approve each potentially-destructive tool call
 * before pi runs it. Two gates:
 *
 *   1. `edit` / `write` — always gated. Shows a unified-diff confirm
 *      dialog rendered via rich-diff's vendored pi-tool-display renderer
 *      so the confirm dialog and the post-execution tool row look
 *      identical.
 *
 *   2. `bash` — gated iff the command is NOT classified as read-only.
 *      Classification uses word-boundary regex patterns modeled after
 *      pi-monorepo/examples/extensions/plan-mode (see `./bash-patterns`).
 *
 * Accepted tool calls are passed through unchanged. Rejected calls
 * return `{ block: true, reason }` so pi records a user-cancellation
 * message in place of the tool result.
 *
 * Cross-extension state: for `edit` / `write`, we compute the unified
 * diff once in this handler and stash it in `rich-diff/patch-cache.ts`
 * keyed by `toolCallId`. rich-diff's renderResult reads from the same
 * cache (both extensions import the same module file → jiti returns
 * the same Map instance).
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { execFile } from "node:child_process";
import { readFile, writeFile, mkdtemp, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join, resolve } from "node:path";
import { patchCache } from "../rich-diff/patch-cache.js";
import { isReadOnlyBash } from "./bash-patterns.js";
import { showDiffConfirm } from "./dialog.js";

interface Edit {
  oldText: string;
  newText: string;
}

/**
 * Apply the tool's edit list to the original file contents. Mirrors the
 * built-in edit tool semantics so our preview diff matches what pi will
 * actually write.
 */
function applyEdits(original: string, edits: Edit[]): string {
  let result = original;
  for (const edit of edits) {
    result = result.replace(edit.oldText, edit.newText);
  }
  return result;
}

/**
 * Shell out to system `diff -u` to produce a unified diff. We use a
 * tmpdir + two temp files rather than in-process diff so the output
 * matches exactly what `git diff` / opencode render, and so we don't
 * re-implement the standard unified-diff format.
 *
 * Uses `execFile` (async) instead of `execFileSync` to avoid blocking
 * the Node.js event loop during tool execution.
 */
async function buildPatch(
  filePath: string,
  original: string,
  newContent: string,
): Promise<string> {
  const dir = await mkdtemp(join(tmpdir(), "permission-gates-"));
  const oldFile = join(dir, "old");
  const newFile = join(dir, "new");
  try {
    await writeFile(oldFile, original);
    await writeFile(newFile, newContent);
    const { stdout, stderr } = await new Promise<{
      stdout: string;
      stderr: string;
    }>((resolve, reject) => {
      const child = execFile("diff", [
        "-u",
        "--label",
        `a/${filePath}`,
        "--label",
        `b/${filePath}`,
        oldFile,
        newFile,
      ]);
      let stdout = "";
      let stderr = "";
      child.stdout?.on("data", (d) => (stdout += d));
      child.stderr?.on("data", (d) => (stderr += d));
      child.on("error", (e) => reject(e));
      child.on("close", (code) => {
        if (code === 0) {
          resolve({ stdout, stderr });
        } else {
          // `diff -u` exits non-zero when files differ — the diff is on
          // stdout. We reject so the caller can handle the patch.
          reject({ stdout, stderr });
        }
      });
    });
    return stdout;
  } catch (e: any) {
    // diff exited non-zero (files differ) — the patch is on stdout.
    // If it's our own rejection shape, use stdout; otherwise return "".
    if (e.stdout) return e.stdout;
    return "";
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    const toolName = event.toolName;

    if (toolName === "edit" || toolName === "write") {
      if (!ctx.hasUI) {
        return { block: true, reason: "Write blocked (no UI)" };
      }

      const filePath = event.input.path as string;
      const absPath = resolve(ctx.cwd, filePath);

      // Read the current file state so we can compute a diff against
      // what the tool is about to write. Missing file is fine (new
      // file case): original stays empty.
      let original = "";
      try {
        original = await readFile(absPath, "utf8");
      } catch {
        // New file — original remains "".
      }

      let newContent: string;
      if (toolName === "edit") {
        const edits = (event.input.edits as Edit[]) ?? [];
        newContent = applyEdits(original, edits);
      } else {
        newContent = event.input.content as string;
      }

      const patch = await buildPatch(filePath, original, newContent);
      // Stash so rich-diff's renderResult override reuses the exact
      // same patch text instead of having to re-derive (or, for
      // `write`, failing to derive at all since the write tool's
      // details don't include a diff).
      patchCache.set(event.toolCallId, { filePath, patch });

      const ok = await showDiffConfirm(ctx, toolName, filePath, patch);
      if (!ok) {
        // User rejected — drop the cached patch so we don't leak
        // entries for calls that never render a result row.
        patchCache.delete(event.toolCallId);
        return { block: true, reason: "Blocked by user" };
      }
      return;
    }

    if (toolName === "bash") {
      const command = (event.input.command as string | undefined) ?? "";
      // Read-only commands auto-approved so the user isn't prompted
      // for every `ls` / `grep` / `git status`.
      if (isReadOnlyBash(command)) return;

      if (!ctx.hasUI) {
        return { block: true, reason: "Bash blocked (no UI)" };
      }
      const description = (event.input.description as string | undefined) ?? "";
      const message = [
        description ? `Description: ${description}` : undefined,
        `$ ${command}`,
      ]
        .filter(Boolean)
        .join("\n\n");
      const ok = await ctx.ui.confirm("Run bash command?", message);
      if (!ok) return { block: true, reason: "Blocked by user" };
      return;
    }
  });
}
