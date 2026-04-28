/**
 * Bash command classifier.
 *
 * Returns true iff we are confident the command has no filesystem, network,
 * or process side effects. Used by confirm-writes to auto-approve read-only
 * shell commands (ls, cat, grep, ...) and prompt for everything else.
 *
 * Rules:
 *   - Reject any output redirection: `>`, `>>`, `&>`, `2>`, etc.
 *   - Reject command substitution `$(...)` and backticks (arbitrary code).
 *   - Reject process substitution `<(...)` / `>(...)`.
 *   - Reject backgrounding `&`.
 *   - Split on `|`, `||`, `&&`, `;` and require every segment's head command
 *     to be in the read-only set.
 *   - `sudo X` / `time X` / `nice X` / `nohup X` are unwrapped.
 *   - `git X` and `nix X` require X to be a read-only subcommand.
 *
 * Conservative by design: false negatives just mean "show the confirm dialog",
 * which is the safe direction.
 */

/** Command heads considered read-only (pure observation). */
const READ_ONLY_COMMANDS = new Set<string>([
  // Listing / inspecting files
  "ls", "ll", "la", "tree", "stat", "file", "readlink", "realpath",
  "pwd", "basename", "dirname",
  // Reading content
  "cat", "bat", "less", "more", "head", "tail", "nl", "od", "hexdump", "xxd",
  "strings", "wc", "cksum", "md5", "md5sum", "sha1sum", "sha256sum", "shasum",
  // Searching
  "grep", "egrep", "fgrep", "rg", "ag", "ack", "find", "fd", "locate",
  // Diffing / comparing
  "diff", "cmp", "comm",
  // Text processing (pure stdin→stdout; redirection is blocked separately)
  "awk", "gawk", "sed", "cut", "sort", "uniq", "tr", "rev", "tac",
  "column", "paste", "fold", "expand", "unexpand", "join",
  "jq", "yq", "xmllint",
  // Info / environment
  "echo", "printf", "true", "false", "yes", "seq", "date", "cal",
  "env", "printenv", "whoami", "id", "groups", "hostname", "uname",
  "uptime", "tty", "which", "whereis", "type", "command", "help", "man",
  "info", "apropos",
  // Process info (no signals)
  "ps", "pgrep", "top", "htop", "btop", "free", "df", "du",
]);

/** Git subcommands that don't mutate repo or working tree. */
const READ_ONLY_GIT_SUBCOMMANDS = new Set<string>([
  "status", "log", "show", "diff", "blame", "branch", "tag",
  "remote", "config", "rev-parse", "rev-list", "ls-files", "ls-tree",
  "cat-file", "describe", "shortlog", "reflog", "grep", "whatchanged",
  "ls-remote", "for-each-ref", "check-ignore", "help", "version",
]);

/** Nix subcommands that don't build, fetch, or mutate state. */
const READ_ONLY_NIX_SUBCOMMANDS = new Set<string>([
  "show-config", "show-derivation", "eval", "derivation", "path-info",
  "hash", "search", "why-depends",
]);

/**
 * Split a command string on `|`, `||`, `&&`, `;`, `&` — but only when the
 * separator is OUTSIDE single quotes, double quotes, and backslash escapes.
 * Also tracks whether any unquoted redirection / substitution token appears,
 * so callers can reject those without the naive regex flagging quoted ones.
 */
interface SplitResult {
  segments: string[];
  hasRedirect: boolean;   // unquoted  >  or  >>  or  N>  or  &>  or  2>&1
  hasCmdSub: boolean;     // unquoted  $(  or  `
  hasProcSub: boolean;    // unquoted  <(  or  >(
  hasTrailingBg: boolean; // unquoted trailing  &
}

/**
 * Treat redirects to /dev/null, &1, &2 as harmless (no filesystem mutation).
 * `pos` points just past the `>` / `>>` / `&>` operator.
 */
function isDiscardTarget(command: string, pos: number): boolean {
  // Skip whitespace.
  while (pos < command.length && (command[pos] === " " || command[pos] === "\t")) pos += 1;
  if (pos >= command.length) return false;
  // `>&1`, `>&2` — fd duplication, no file touched.
  if (command[pos] === "&" && (command[pos + 1] === "1" || command[pos + 1] === "2")) {
    return true;
  }
  // `/dev/null` literal with a word boundary after it (not `/dev/nullish`).
  if (!command.startsWith("/dev/null", pos)) return false;
  const after = command[pos + "/dev/null".length];
  return after === undefined || /[\s|;&<>)]/.test(after);
}

function splitCommand(command: string): SplitResult {
  const segments: string[] = [];
  let current = "";
  let i = 0;
  let inSingle = false;
  let inDouble = false;
  let hasRedirect = false;
  let hasCmdSub = false;
  let hasProcSub = false;
  let hasTrailingBg = false;

  const push = () => {
    const t = current.trim();
    if (t) segments.push(t);
    current = "";
  };

  while (i < command.length) {
    const c = command[i];
    const next = command[i + 1];
    const prev = command[i - 1];

    // Backslash escape (outside single quotes): consume next char literally.
    if (!inSingle && c === "\\" && next !== undefined) {
      current += c + next;
      i += 2;
      continue;
    }

    if (!inDouble && c === "'") {
      inSingle = !inSingle;
      current += c;
      i += 1;
      continue;
    }
    if (!inSingle && c === '"') {
      inDouble = !inDouble;
      current += c;
      i += 1;
      continue;
    }

    if (inSingle || inDouble) {
      current += c;
      i += 1;
      continue;
    }

    // Unquoted: scan for separators and side-effect tokens.
    if (c === "|" && next === "|") {
      push();
      i += 2;
      continue;
    }
    if (c === "&" && next === "&") {
      push();
      i += 2;
      continue;
    }
    if (c === "|") {
      push();
      i += 1;
      continue;
    }
    if (c === ";") {
      push();
      i += 1;
      continue;
    }
    if (c === "&") {
      // Standalone `&` — either backgrounding, an fd-redirect like `&>`,
      // or the fd-duplication operator `>&` / `N>&M` (part of the previous
      // `>` token, already consumed as a redirect; here we emit the `&N`
      // into `current` so it stays attached to the segment and doesn't get
      // treated as a backgrounding separator).
      if (prev === ">") {
        // `>&N` fd-duplication — not a separator. Attach to current segment.
        current += c;
        i += 1;
        continue;
      }
      if (next === ">") {
        // `&>` or `&>>` — check if target is /dev/null (harmless).
        let afterGt = i + 2;
        if (command[afterGt] === ">") afterGt += 1; // `&>>`
        if (!isDiscardTarget(command, afterGt)) hasRedirect = true;
        current += c;
        i += 1;
        continue;
      }
      // Trailing bg if no non-whitespace after this point.
      const restTrim = command.slice(i + 1).trim();
      if (restTrim === "" || restTrim.startsWith("#")) hasTrailingBg = true;
      push();
      i += 1;
      continue;
    }

    // Redirection detection (unquoted only).
    if (c === ">" && prev !== "<") {
      // Could be `>`, `>>`, `>(` (proc sub), or part of `2>` / `N>`.
      if (next === "(") {
        hasProcSub = true;
      } else {
        // Skip `>` or `>>` and check if target is /dev/null or &1/&2.
        let afterGt = i + 1;
        if (command[afterGt] === ">") afterGt += 1; // `>>`
        if (!isDiscardTarget(command, afterGt)) hasRedirect = true;
      }
      current += c;
      i += 1;
      continue;
    }
    if (c === "<" && next === "(") {
      hasProcSub = true;
      current += c;
      i += 1;
      continue;
    }

    // Command substitution.
    if (c === "$" && next === "(") {
      hasCmdSub = true;
      current += c;
      i += 1;
      continue;
    }
    if (c === "`") {
      hasCmdSub = true;
      current += c;
      i += 1;
      continue;
    }

    current += c;
    i += 1;
  }
  push();

  return { segments, hasRedirect, hasCmdSub, hasProcSub, hasTrailingBg };
}

export function isReadOnlyBash(command: string): boolean {
  if (!command || !command.trim()) return true;

  const parsed = splitCommand(command);
  if (parsed.hasRedirect || parsed.hasCmdSub || parsed.hasProcSub || parsed.hasTrailingBg) {
    return false;
  }

  if (parsed.segments.length === 0) return true;

  for (const seg of parsed.segments) {
    if (!isReadOnlySegment(seg)) return false;
  }
  return true;
}

function isReadOnlySegment(segment: string): boolean {
  // Strip leading `VAR=value` env assignments.
  let rest = segment.replace(/^(?:[A-Za-z_][A-Za-z0-9_]*=\S*\s+)+/, "");
  // Strip leading `sudo` with optional short flags.
  rest = rest.replace(/^sudo(?:\s+-[A-Za-z]+)*\s+/, "");
  // Strip leading `time` / `nice` / `nohup` wrappers.
  rest = rest.replace(/^(?:time|nice(?:\s+-n\s+-?\d+)?|nohup)\s+/, "");

  const tokens = rest.split(/\s+/);
  const head = tokens[0];
  if (!head) return true;

  // Pure variable assignment segment like `FOO=bar` with no command.
  if (/^[A-Za-z_][A-Za-z0-9_]*=/.test(head) && tokens.length === 1) return true;

  if (READ_ONLY_COMMANDS.has(head)) return true;

  if (head === "git") {
    const sub = tokens[1];
    return !!sub && READ_ONLY_GIT_SUBCOMMANDS.has(sub);
  }

  if (head === "nix") {
    const sub = tokens[1];
    return !!sub && READ_ONLY_NIX_SUBCOMMANDS.has(sub);
  }

  return false;
}
