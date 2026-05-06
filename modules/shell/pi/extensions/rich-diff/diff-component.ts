/**
 * Reusable diff-rendering utilities for the vendored pi-tool-display
 * renderer. Exported for other extensions (e.g. permission-gates) to
 * render the same opencode-style split/unified diff inside their own
 * UI (confirm dialogs, tool-result overlays, etc.).
 */

import type { Component } from "@mariozechner/pi-tui";
import { renderEditDiffResult } from "./vendor/diff-renderer.js";
import { DEFAULT_TOOL_DISPLAY_CONFIG } from "./vendor/types.js";

export { renderEditDiffResult } from "./vendor/diff-renderer.js";
export { DEFAULT_TOOL_DISPLAY_CONFIG } from "./vendor/types.js";

/**
 * Build a diff component using the vendored pi-tool-display renderer.
 *
 * Three adjustments over a naive call to `renderEditDiffResult`:
 *
 * 1. **Hide container background slots** (`toolSuccessBg` / `toolPendingBg`
 *    / `toolErrorBg` / `userMessageBg`) so the inner renderer doesn't mix
 *    its own row backgrounds with pi's outer row tint. A `Proxy` around
 *    the theme intercepts `getBgAnsi(color)` to return `""` for those slots.
 *
 * 2. **Strip unified-diff chrome lines** (`--- path`, `+++ path`, git meta)
 *    from the patch text before parsing. These add no information for a
 *    single-file in-line diff and render as unstyled context rows that
 *    inherit the outer green tint, producing a visually distinct top band.
 *
 *    `@@ hunk @@` lines are **kept** — the vendored renderer parses them
 *    to assign old/new line numbers; dropping them produces empty
 *    line-number columns.
 *
 * 3. **Cancel the outer `toolSuccessBg` per line** by prepending `\x1b[49m`
 *    to every rendered line. pi's outer `Box.bgFn` wraps our line as
 *    `\x1b[42m{line}\x1b[49m`; a leading `\x1b[49m` immediately cancels the
 *    `\x1b[42m` so cells the vendor renderer leaves un-painted show the
 *    terminal's default background instead of the tool-row's success green.
 *
 * 4. **Add a 1-col left pad BEFORE the bg reset** so the pad itself
 *    inherits the outer tool-row bg (success green / error red). This
 *    aligns the diff block with the `edit <path>` / `write <path>`
 *    header (which has its own `paddingX=1`) while keeping the diff
 *    content area on the terminal's default bg.
 */
export function buildDiffComponent(
  patch: string,
  filePath: string,
  theme: any,
  expanded: boolean,
): Component {
  const diffTheme = makeDiffTheme(theme);
  const stripped = stripUnifiedChrome(patch);
  const inner = renderEditDiffResult(
    { diff: stripped },
    { expanded, filePath },
    { ...DEFAULT_TOOL_DISPLAY_CONFIG, diffInlineEmphasis: false },
    diffTheme,
    "",
  );

  return {
    render(width: number): string[] {
      // Render vendor at width - 1 to reserve a column for our left pad.
      // Pad is a plain space emitted BEFORE `\x1b[49m` so it stays on the
      // outer Box's bg (toolSuccessBg / toolErrorBg); the reset only
      // applies to the diff content that follows.
      const innerWidth = Math.max(1, width - 1);
      return inner.render(innerWidth).map((line) => `\x1b[49m${line}`);
    },
    invalidate(): void {
      inner.invalidate?.();
    },
  };
}

/**
 * Theme proxy that blanks out container-background slots. Exported so
 * callers who drive `renderEditDiffResult` directly (e.g. a custom
 * scrolling overlay) can reuse the exact same background handling.
 */
export function makeDiffTheme(theme: any): any {
  return new Proxy(theme, {
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
}

/**
 * Strip unified-diff file metadata lines. Input `patch` is what `diff -u`
 * produced for a single file; we drop:
 *
 *   - `--- path` / `+++ path`  (file meta — the path already appears in
 *                               the tool's renderCall header)
 *   - `diff --git ...`, `index ...`, `rename from/to`, `new file mode`,
 *     `deleted file mode` (extended git meta)
 *
 * We deliberately **keep `@@ hunk @@` lines** — the vendored renderer
 * parses them to assign old/new line numbers to each diff row. Dropping
 * them would produce rows with empty line-number columns. The vendor
 * renders hunk headers as a subtle muted line (see `formatMetaEntryRows`
 * in `vendor/diff-renderer.ts`).
 */
export function stripUnifiedChrome(patch: string): string {
  const lines = patch.split("\n");
  const out: string[] = [];
  for (const line of lines) {
    if (
      line.startsWith("--- ") ||
      line.startsWith("+++ ") ||
      line.startsWith("diff --git") ||
      line.startsWith("index ") ||
      line.startsWith("rename from ") ||
      line.startsWith("rename to ") ||
      line.startsWith("new file mode ") ||
      line.startsWith("deleted file mode ")
    ) {
      continue;
    }
    out.push(line);
  }
  return out.join("\n");
}
