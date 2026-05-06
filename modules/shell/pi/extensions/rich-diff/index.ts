/**
 * rich-diff extension
 *
 * Replaces the built-in `edit` / `write` tool renderers so their
 * post-execution tool rows show an opencode-style split (or unified, at
 * narrow widths) diff instead of the default foreground-only unified
 * output. Uses the vendored `pi-tool-display` renderer in `./vendor/`.
 *
 * Exposes diff-component utilities (`buildDiffComponent`,
 * `stripUnifiedChrome`, `makeDiffTheme`, `renderEditDiffResult`,
 * `DEFAULT_TOOL_DISPLAY_CONFIG`) and a shared `patchCache` so other
 * extensions (e.g. permission-gates) can:
 *
 *   - Render the same diff in their own overlays (confirm dialogs).
 *   - Populate `patchCache` with a pre-computed patch keyed by
 *     `toolCallId` so this extension's `renderResult` reuses it instead
 *     of re-deriving from `details.diff` (write-tool `details` has no
 *     `diff` field; caching is the only way to keep write-tool output
 *     visually consistent with edit-tool output).
 */

import type {
  EditToolDetails,
  ExtensionAPI,
} from "@mariozechner/pi-coding-agent";
import {
  createEditTool,
  createWriteTool,
} from "@mariozechner/pi-coding-agent";
import { Text } from "@mariozechner/pi-tui";
import { appendFileSync } from "node:fs";
import { buildDiffComponent } from "./diff-component.js";
import { patchCache } from "./patch-cache.js";

// Re-exports for other extensions (permission-gates, etc.).
export {
  buildDiffComponent,
  makeDiffTheme,
  stripUnifiedChrome,
  renderEditDiffResult,
  DEFAULT_TOOL_DISPLAY_CONFIG,
} from "./diff-component.js";
export { patchCache } from "./patch-cache.js";

export default function (pi: ExtensionAPI) {
  // `createEditTool(cwd)` / `createWriteTool(cwd)` return the built-in
  // tool instances. We delegate `execute` to them and only override the
  // renderers so file I/O behavior is unchanged.
  const cwd = process.cwd();
  const originalEdit = createEditTool(cwd);
  const originalWrite = createWriteTool(cwd);

  pi.registerTool({
    name: "edit",
    label: "edit",
    description: originalEdit.description,
    parameters: originalEdit.parameters,
    async execute(toolCallId, params, signal, onUpdate) {
      return originalEdit.execute(toolCallId, params, signal, onUpdate);
    },
    renderCall(args, theme, context) {
      const path = (args as { path?: string })?.path ?? "";
      return new Text(`${theme.fg("toolTitle", theme.bold("edit"))} ${theme.fg("accent", path)}`, 0, 0);
    },
    renderResult(result, { isPartial, expanded }, theme, context) {
      if (isPartial) return new Text(theme.fg("warning", "Editing..."), 0, 0);
      const content = result.content[0];
      if (content?.type === "text" && content.text.startsWith("Error")) {
        return new Text(theme.fg("error", content.text.split("\n")[0]), 0, 0);
      }
      // `edit` tool's details carry a `diff` string. Prefer a
      // pre-computed patch from `patchCache` (populated by
      // permission-gates during its confirm step) so the tool row shows
      // the exact same diff the user approved. Fall back to
      // `details.diff` if the cache is empty (e.g. when rich-diff is
      // active without permission-gates).
      const details = result.details as EditToolDetails | undefined;
      const cached = patchCache.get(context.toolCallId);
      const patch = cached?.patch ?? details?.diff ?? "";
      const filePath =
        cached?.filePath ?? (context.args as { path?: string }).path ?? "";
      if (!patch.trim()) {
        return new Text(theme.fg("muted", "↳ no changes"), 0, 0);
      }
      return buildDiffComponent(patch, filePath, theme, expanded);
    },
  });

  pi.registerTool({
    name: "write",
    label: "write",
    description: originalWrite.description,
    parameters: originalWrite.parameters,
    async execute(toolCallId, params, signal, onUpdate) {
      return originalWrite.execute(toolCallId, params, signal, onUpdate);
    },
    // Built-in `formatWriteCall` shows `write <path>` plus the first 10
    // lines of new content as a preview. Since our `renderResult` shows
    // the full diff (which already includes the added lines with line
    // numbers), that built-in preview is just duplicated noise. Collapse
    // the header to just `write <path>` so the tool row reads as
    // `write <path>` then the diff.
    renderCall(args, theme, _context) {
      const path = (args as { path?: string } | undefined)?.path ?? "";
      return new Text(
        `${theme.fg("toolTitle", theme.bold("write"))} ${theme.fg(
          "accent",
          path,
        )}`,
        0,
        0,
      );
    },
    renderResult(result, { isPartial, expanded }, theme, context) {
      if (isPartial) return new Text(theme.fg("warning", "Writing..."), 0, 0);
      const content = result.content[0];
      if (content?.type === "text" && content.text.startsWith("Error")) {
        return new Text(theme.fg("error", content.text.split("\n")[0]), 0, 0);
      }
      // `write` tool's built-in details do NOT include a diff, so we
      // depend entirely on `patchCache` being populated upstream. If
      // nothing is cached, fall back to a plain "Written" message —
      // rendering a diff would require re-reading the file, which the
      // `write` call just mutated.
      const cached = patchCache.get(context.toolCallId);
      const patch = cached?.patch ?? "";
      const filePath =
        cached?.filePath ?? (context.args as { path?: string }).path ?? "";
      if (!patch.trim()) {
        return new Text(theme.fg("success", "Written"), 0, 0);
      }
      return buildDiffComponent(patch, filePath, theme, expanded);
    },
  });
}
