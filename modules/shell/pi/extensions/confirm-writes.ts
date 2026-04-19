/**
 * Confirm Writes Extension
 *
 * Prompts for confirmation before any edit or write tool call.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName !== "edit" && event.toolName !== "write") return;
    if (!ctx.hasUI) return { block: true, reason: "Write blocked (no UI)" };

    const path = event.input.path as string;
    const choice = await ctx.ui.select(
      `${event.toolName}: ${path}\n\nAllow?`,
      ["Yes", "No"]
    );

    if (choice !== "Yes") {
      return { block: true, reason: "Blocked by user" };
    }
  });
}
