/**
 * Diff-confirmation dialog for the permission-gates extension.
 *
 * Opens a pi overlay / editor-attached custom component showing a
 * unified/split diff with a yes/no SelectList, and a tab-toggled
 * full-screen expanded mode with a scrollable viewport.
 *
 * Delegates all diff layout to rich-diff's vendored pi-tool-display
 * renderer (via `renderEditDiffResult` + `makeDiffTheme` re-exported
 * from `../rich-diff/diff-component.js`) so the dialog's visuals are
 * identical to the post-execution tool-result diff.
 *
 * The renderer produces rows that are:
 *   - Exactly `contentCols` wide
 *   - Already bg-painted for add/remove/context
 *   - SGR-balanced **per row** but NOT between rows (vendor leaves the
 *     row-bg active until the next row overrides it)
 *
 * Everything that follows (scrolling viewport, sticky header, collapsed
 * join-on-newline) prepends a `\x1b[0m` per row to guarantee a clean
 * starting SGR state — without that, context rows (which have no
 * row-bg of their own) inherit the previous row's add/remove bg.
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
import {
  DEFAULT_TOOL_DISPLAY_CONFIG,
  makeDiffTheme,
  renderEditDiffResult,
} from "../rich-diff/diff-component.js";

/** Max lines shown inline before the "... N more" truncation footer. */
const COLLAPSED_LINES = 20;

type DialogOutcome = "yes" | "no" | "toggle";

/**
 * Prompt the user to approve or reject a diff. Loops on tab-toggle so
 * the overlay / editor-attached modes swap in place while the
 * scroll/expanded state is preserved.
 */
export async function showDiffConfirm(
  ctx: Parameters<Parameters<ExtensionAPI["on"]>[1]>[1],
  toolName: string,
  filePath: string,
  patch: string,
): Promise<boolean> {
  const state = { expanded: false, scroll: 0 };
  while (true) {
    const outcome = await openDialog(ctx, toolName, filePath, patch, state);
    if (outcome === "yes") return true;
    if (outcome === "no") return false;
    // tab pressed: flip the expanded state and reopen in the other
    // overlay mode. Scroll resets since the layout is different.
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

      // The dialog renders the full diff (expanded: true) and does its
      // own collapsed-mode truncation with a footer — the vendor's
      // built-in collapsed-mode hint is tuned for tool rows, not for a
      // tab-expandable confirm dialog.
      const diffTheme = makeDiffTheme(theme);
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
          return true;
        });
      }

      let cachedAllLines: string[] = [];
      let cachedAllWidth = -1;
      function getAllLines(contentCols: number): string[] {
        // Vendor emits each row at exactly `contentCols` wide with row
        // background painted across the full width and SGR state
        // balanced per row. Use the lines verbatim — no re-truncate,
        // no re-pad, no reset injection — because any of those would
        // inject stray `\x1b[0m` mid-row and break vendor's row-bg.
        if (cachedAllWidth !== contentCols) {
          cachedAllLines = stripChrome(diffComponent.render(contentCols));
          cachedAllWidth = contentCols;
        }
        return cachedAllLines;
      }

      let expanded = state.expanded;
      let scroll = state.scroll;

      // Vendor emits add/remove rows with a painted rowBg but context
      // rows with no rowBg. When rows are concatenated via join("\n") or
      // stacked vertically, a bgless context row inherits the previous
      // row's still-active rowBg. Prepending `\x1b[0m` per row gives a
      // clean starting SGR state — safe because it only cancels state
      // that leaked in from above.
      const cleanStart = (line: string) => `\x1b[0m${line}`;

      const diffText = new Text("", 0, 0, cleanStart);
      const stickyHead = new Text("", 0, 0, cleanStart);
      const hintText = new Text("", 1, 0);

      /**
       * Scrolling viewport for the diff body with a scrollbar in the
       * last column. State lives outside the component (getter callbacks)
       * so scroll/resize handlers in the parent just update closure
       * vars and request a render — the component stays a pure function
       * of its inputs.
       *
       * Parent pre-renders body lines via the vendor at exactly
       * `contentCols = width - 1`, reserving 1 col for the scrollbar.
       * We emit each vendor line verbatim + one scrollbar glyph.
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
          const contentCols = Math.max(1, width - 1);

          let scrollPos = this.getScroll();
          const maxScroll = Math.max(0, total - visibleRows);
          if (scrollPos > maxScroll) scrollPos = maxScroll;
          if (scrollPos < 0) scrollPos = 0;

          let thumbStart = 0;
          let thumbEnd = 0;
          if (needBar) {
            const thumbSize = Math.max(
              1,
              Math.floor((visibleRows * visibleRows) / total),
            );
            const maxScrollForBar = Math.max(1, total - visibleRows);
            thumbStart = Math.floor(
              (scrollPos / maxScrollForBar) * (visibleRows - thumbSize),
            );
            thumbEnd = thumbStart + thumbSize;
          }

          const slice = bodyLines.slice(scrollPos, scrollPos + visibleRows);
          const emptyPad = " ".repeat(contentCols);
          const out: string[] = [];
          for (let i = 0; i < visibleRows; i++) {
            const raw = slice[i];
            const body = raw !== undefined ? raw : emptyPad;
            const bar = needBar
              ? i >= thumbStart && i < thumbEnd
                ? theme.fg("accent", "█")
                : theme.fg("dim", "│")
              : " ";
            out.push(`\x1b[0m${body}${bar}`);
          }
          return out;
        }
      }

      // Derived state for the expanded viewport. Recomputed in refresh()
      // so DiffViewport stays a pure function.
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
        const allLines = getAllLines(contentCols);
        const total = allLines.length;
        const visible =
          total <= COLLAPSED_LINES
            ? allLines
            : [
                ...allLines.slice(0, COLLAPSED_LINES),
                theme.fg(
                  "dim",
                  `   … ${total - COLLAPSED_LINES} more lines (tab to expand)`,
                ),
              ];
        // Append `\x1b[0m` per line so pi-tui's AnsiCodeTracker sees the
        // row's SGR fully closed at each newline — otherwise context
        // rows inherit the previous row's bg when pi-tui re-prepends
        // still-active codes across line boundaries.
        return visible.map((l) => `${l}\x1b[0m`).join("\n");
      }

      function computeExpandedViewport(): void {
        const termCols = tui.terminal.columns ?? 80;
        const termRows = tui.terminal.rows ?? 40;
        // 1 col reserved for the scrollbar.
        const contentCols = Math.max(20, termCols - 1);
        const allLines = getAllLines(contentCols);
        // Vendor emits `[summary, frame, ...body, (frame)]`. Pin the
        // first 2 rows so redrawing on each scroll tick only touches
        // the body, shrinking TUI's diff range.
        const stickyTop = Math.min(2, allLines.length);
        const headLines = allLines.slice(0, stickyTop);
        const bodyLines = allLines.slice(stickyTop);
        // Chrome = title(1) + titleBorder(1) + hint(1) + bottomBorder(1)
        const visibleRows = Math.max(10, termRows - 4 - stickyTop);

        viewportVisibleRows = visibleRows;
        viewportBodyLines = bodyLines;

        const maxScroll = Math.max(
          0,
          viewportBodyLines.length - visibleRows,
        );
        if (scroll > maxScroll) scroll = maxScroll;
        if (scroll < 0) scroll = 0;

        stickyHead.setText(headLines.map((l) => `${l}\x1b[0m`).join("\n"));
      }

      function updateHint() {
        const termCols = tui.terminal.columns ?? 80;
        if (expanded) {
          const maxScroll = Math.max(
            0,
            viewportBodyLines.length - viewportVisibleRows,
          );
          hintText.setText(
            theme.fg(
              "dim",
              `tab collapse • j/k C-d/C-u g/G (${scroll}/${maxScroll}) • esc cancel`,
            ),
          );
        } else {
          const contentCols = Math.max(20, termCols);
          const totalLines = getAllLines(contentCols).length;
          hintText.setText(
            theme.fg(
              "dim",
              totalLines > COLLAPSED_LINES
                ? "↑↓ navigate • enter select • esc cancel • tab expand diff"
                : "↑↓ navigate • enter select • esc cancel",
            ),
          );
        }
      }

      const container = new Container();
      const titleText = new Text(
        theme.fg("accent", theme.bold(`${toolName}: `)) +
          theme.fg("text", filePath),
        1,
        0,
      );
      const titleBorder = new DynamicBorder((s: string) =>
        theme.fg("accent", s),
      );
      const spacer = new Text("", 0, 0);
      const bottomBorder = new DynamicBorder((s: string) =>
        theme.fg("accent", s),
      );

      function rebuildChildren() {
        container.clear();
        container.addChild(titleText);
        container.addChild(titleBorder);
        if (expanded) {
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
        if (expanded) computeExpandedViewport();
        else diffText.setText(computeCollapsedText());
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
          // Re-derive diff text on width change so the vendor can
          // auto-flip between unified/split and our truncation updates.
          if (w !== lastRenderWidth) {
            lastRenderWidth = w;
            refresh();
          }
          const lines = container.render(w);
          if (expanded) {
            // Fill to full terminal height so overlay covers chrome.
            const termRows = tui.terminal.rows ?? 40;
            while (lines.length < termRows) lines.push("");
            return lines.slice(0, termRows);
          }
          return lines;
        },
        invalidate() {
          container.invalidate();
        },
        handleInput(data: string) {
          if (matchesKey(data, "tab")) {
            done("toggle");
            return;
          }
          if (expanded) {
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
            if (matchesKey(data, "escape")) {
              selectList.handleInput(data);
              return;
            }
            // Enter confirms the edit/write while in expanded diff view.
            if (matchesKey(data, "return") || matchesKey(data, "enter")) {
              done("yes");
              return;
            }
            // Swallow everything else so stray keys don't hit the hidden
            // select list (which would accept a default answer).
            return;
          }
          // Collapsed: map j/k to arrow keys for vim-style list nav.
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
          // Expanded: full-screen overlay anchored bottom-left so it
          // covers the spinner and chat scrollback entirely.
          overlayOptions: () => {
            const cols = (process.stdout.columns as number | undefined) ?? 80;
            const rows = (process.stdout.rows as number | undefined) ?? 40;
            return {
              anchor: "bottom-left" as const,
              width: cols,
              maxHeight: rows,
            };
          },
        }
      : {
          // Collapsed: attach to the editor container so the dialog
          // sits below the chat history without covering messages.
          overlay: false,
        },
  );
}
