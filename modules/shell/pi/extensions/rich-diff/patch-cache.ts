/**
 * Shared per-tool-call patch cache.
 *
 * Populated by upstream `tool_call` handlers (e.g. permission-gates) when
 * they compute a unified-diff for a confirm dialog. Consumed by the
 * `edit` / `write` tool `renderResult` overrides in rich-diff so the
 * post-execution tool row shows the exact same diff without recomputing.
 *
 * Keyed by toolCallId. Entries are cleared by the consumer.
 *
 * Extensions are loaded as separate jiti modules, but when two extension
 * files both `import` this path, jiti's module cache gives them the same
 * `Map` instance — so permission-gates and rich-diff share state.
 */
export const patchCache = new Map<string, { filePath: string; patch: string }>();
