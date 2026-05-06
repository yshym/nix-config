/**
 * Bash command classification via word-boundary regex patterns.
 *
 * Modeled after pi-monorepo/examples/extensions/plan-mode/utils.ts: we
 * scan the raw command string for destructive markers (`\brm\b`, `>`,
 * ...) and for known-safe command heads (`^\s*ls\b`, `^\s*cat\b`, ...).
 * A command is auto-approved iff it matches at least one SAFE pattern
 * and no DESTRUCTIVE pattern.
 *
 * This deliberately avoids a hand-rolled tokenizer that walks pipes,
 * heredocs, command substitution, and quoting — plan-mode has shipped
 * with this simple regex approach for a while and the redundancy of
 * re-scanning the full string per pattern is trivially cheap.
 *
 * Conservative by design: false negatives just mean "show the confirm
 * dialog", which is the safe direction.
 */

/**
 * If any of these patterns match, treat the command as destructive and
 * prompt the user — even if a SAFE pattern also matches. Word-boundary
 * (`\b`) anchoring means `head` inside a longer identifier like
 * `headless` does not trigger anything.
 *
 * Kept close to plan-mode's list, with small additions for this
 * extension's needs (`tee`, `shred`, redirection).
 */
const DESTRUCTIVE_PATTERNS: RegExp[] = [
  // Filesystem mutation
  /\brm\b/i,
  /\brmdir\b/i,
  /\bmv\b/i,
  /\bcp\b/i,
  /\bmkdir\b/i,
  /\btouch\b/i,
  /\bchmod\b/i,
  /\bchown\b/i,
  /\bchgrp\b/i,
  /\bln\b/i,
  /\btee\b/i,
  /\btruncate\b/i,
  /\bdd\b/i,
  /\bshred\b/i,

  // Output redirection (writes to a file).
  //   - `>foo` / `> foo`        (but not `>>`, handled separately, and
  //                              not heredoc/herestring `<<` tails)
  //   - `>>foo`
  // We deliberately do NOT match `>` to /dev/null or `>&N` fd-dup
  // because redirecting to /dev/null or duplicating fds is harmless.
  /(^|[^<])>(?!>)(?!\s*\/dev\/null)(?!>&)(?!&\d)/,
  />>(?!\s*\/dev\/null)/,

  // Package managers (install / remove / publish mutate state).
  /\bnpm\s+(install|uninstall|update|ci|link|publish)\b/i,
  /\byarn\s+(add|remove|install|publish)\b/i,
  /\bpnpm\s+(add|remove|install|publish)\b/i,
  /\bpip\s+(install|uninstall)\b/i,
  /\bapt(-get)?\s+(install|remove|purge|update|upgrade)\b/i,
  /\bbrew\s+(install|uninstall|upgrade)\b/i,

  // Git mutations (excludes read-only subcommands).
  /\bgit\s+(add|commit|push|pull|merge|rebase|reset|checkout|branch\s+-[dD]|stash|cherry-pick|revert|tag|init|clone|fetch|rm|mv)\b/i,

  // Nix mutations.
  /\bnix\s+(build|profile|store|copy|flake\s+(update|lock)|run\s)/i,
  /\bnix-env\b/i,
  /\bnix-store\s+--(delete|add)/i,
  /\bdarwin-rebuild\b/i,
  /\bhome-manager\b/i,
  /\bnixos-rebuild\b/i,

  // Privilege escalation.
  /\bsudo\b/i,
  /\bdoas\b/i,
  /\bsu\b/i,

  // Process / system control.
  /\bkill\b/i,
  /\bpkill\b/i,
  /\bkillall\b/i,
  /\breboot\b/i,
  /\bshutdown\b/i,
  /\bsystemctl\s+(start|stop|restart|enable|disable)\b/i,
  /\bservice\s+\S+\s+(start|stop|restart)\b/i,
  /\blaunchctl\s+(load|unload|kickstart|bootstrap|bootout)\b/i,

  // Network file download (fetches data to disk).
  /\bcurl\b/i,
  /\bwget\b/i,

  // Interactive editors (they can write files and the agent can't
  // interact with them usefully anyway).
  /\b(vim?|nano|emacs|code|subl)\b/i,
];

/**
 * If any of these match AND no DESTRUCTIVE_PATTERNS match, the command
 * is considered read-only and auto-approved. Anchored at start-of-line
 * (after optional whitespace) so the safety judgement is based on the
 * leading command, not a piped-to tail.
 *
 * Pipes are implicitly handled by plan-mode's trick: destructive
 * patterns are NOT anchored to start-of-line, so `grep foo | rm bar`
 * matches `\brm\b` and is rejected. A bare `ls | wc -l` matches `^\s*ls\b`
 * here, and nothing in DESTRUCTIVE_PATTERNS matches `wc`, so it's safe.
 */
const SAFE_PATTERNS: RegExp[] = [
  // File viewing / listing
  /^\s*cat\b/,
  /^\s*bat\b/,
  /^\s*head\b/,
  /^\s*tail\b/,
  /^\s*less\b/,
  /^\s*more\b/,
  /^\s*ls\b/,
  /^\s*ll\b/,
  /^\s*la\b/,
  /^\s*tree\b/,
  /^\s*exa\b/,
  /^\s*pwd\b/,
  /^\s*basename\b/,
  /^\s*dirname\b/,
  /^\s*readlink\b/,
  /^\s*realpath\b/,
  /^\s*file\b/,
  /^\s*stat\b/,

  // Searching
  /^\s*grep\b/i,
  /^\s*egrep\b/,
  /^\s*fgrep\b/,
  /^\s*rg\b/,
  /^\s*ag\b/,
  /^\s*ack\b/,
  /^\s*find\b/,
  /^\s*fd\b/,
  /^\s*locate\b/,

  // Hashing / comparing
  /^\s*diff\b/,
  /^\s*cmp\b/,
  /^\s*comm\b/,
  /^\s*md5sum?\b/,
  /^\s*sha\d+sum\b/,
  /^\s*shasum\b/,
  /^\s*cksum\b/,

  // Text processing
  /^\s*awk\b/,
  /^\s*gawk\b/,
  /^\s*sed\s+-n\b/i, // `sed -n` is read-only-ish (no in-place writes).
  /^\s*cut\b/,
  /^\s*sort\b/,
  /^\s*uniq\b/,
  /^\s*tr\b/,
  /^\s*rev\b/,
  /^\s*tac\b/,
  /^\s*column\b/,
  /^\s*paste\b/,
  /^\s*fold\b/,
  /^\s*wc\b/,
  /^\s*jq\b/,
  /^\s*yq\b/,
  /^\s*xmllint\b/,

  // Info / environment
  /^\s*echo\b/,
  /^\s*printf\b/,
  /^\s*true\b/,
  /^\s*false\b/,
  /^\s*yes\b/,
  /^\s*seq\b/,
  /^\s*date\b/,
  /^\s*cal\b/,
  /^\s*env\b/,
  /^\s*printenv\b/,
  /^\s*whoami\b/,
  /^\s*id\b/,
  /^\s*groups\b/,
  /^\s*hostname\b/,
  /^\s*uname\b/,
  /^\s*uptime\b/,
  /^\s*tty\b/,
  /^\s*which\b/,
  /^\s*whereis\b/,
  /^\s*type\b/,
  /^\s*command\b/,
  /^\s*help\b/,
  /^\s*man\b/,
  /^\s*info\b/,
  /^\s*apropos\b/,

  // Process info (no signals)
  /^\s*ps\b/,
  /^\s*pgrep\b/,
  /^\s*top\b/,
  /^\s*htop\b/,
  /^\s*btop\b/,
  /^\s*free\b/,
  /^\s*df\b/,
  /^\s*du\b/,

  // Read-only VCS / package / tool info
  /^\s*git\s+(status|log|diff|show|blame|branch|tag|remote|config(\s+--get\b)?|rev-parse|rev-list|ls-files|ls-tree|ls-remote|cat-file|describe|shortlog|reflog|grep|whatchanged|for-each-ref|check-ignore|help|version)\b/i,
  /^\s*npm\s+(list|ls|view|info|search|outdated|audit)\b/i,
  /^\s*yarn\s+(list|info|why|audit)\b/i,
  /^\s*pnpm\s+(list|ls|why|outdated)\b/i,
  /^\s*nix\s+(show-config|show-derivation|eval|derivation|path-info|hash|search|why-depends)\b/i,
  /^\s*node\s+--version\b/i,
  /^\s*python\s+--version\b/i,
];

/**
 * True iff the command is confidently read-only. Returns false for
 * destructive commands and for commands that don't match any known
 * SAFE_PATTERN (conservative default).
 */
export function isReadOnlyBash(command: string): boolean {
  if (!command || !command.trim()) return true;

  if (DESTRUCTIVE_PATTERNS.some((p) => p.test(command))) return false;
  if (!SAFE_PATTERNS.some((p) => p.test(command))) return false;
  return true;
}
