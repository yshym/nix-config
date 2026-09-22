#!/usr/bin/env bash
#
# install.sh — install this flake's configuration for a NixOS or nix-darwin host.
#
# NixOS (run from the installer environment, target mounted at --root):
#   ./install.sh --root /mnt --flake /mnt/etc/dotfiles --host atlas
#
# nix-darwin (run on the target Mac, with Nix already installed):
#   ./install.sh --flake ~/.nixpkgs --host mbp16
#
# The host is looked up in the flake's `nixosConfigurations` (Linux) or
# `darwinConfigurations` (Darwin); the script errors out if it does not exist.
#
# This script does NOT partition or format disks. On NixOS the target must
# already be mounted at --root; on macOS the account and Nix must already exist.

set -euo pipefail

PROG="$(basename "$0")"

flake=""
host=""
root="/mnt"
dry_run=0

usage() {
  cat <<EOF
Usage: $PROG --flake PATH --host HOST [--root DIR] [--dry-run]

Options:
  --flake PATH   Path (or URL) to the flake to install. Required.
  --host HOST    Host/configuration name to install. Required.
  --root DIR     NixOS install root (target mount point). Default: /mnt.
                 Ignored on Darwin.
  --dry-run      Print the commands that would run, without running them.
  -h, --help     Show this help.
EOF
}

log()  { printf '%s\n' "$*" >&2; }
die()  { printf '%s: %s\n' "$PROG" "$*" >&2; exit 1; }

run() {
  if [ "$dry_run" -eq 1 ]; then
    printf '+ ' >&2
    printf '%q ' "$@" >&2
    printf '\n' >&2
  else
    "$@"
  fi
}

# parse arguments

while [ $# -gt 0 ]; do
  case "$1" in
    --flake)   flake="${2:-}"; shift 2 ;;
    --host)    host="${2:-}";  shift 2 ;;
    --root)    root="${2:-}";  shift 2 ;;
    --dry-run) dry_run=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown argument: $1 (try --help)" ;;
  esac
done

[ -n "$flake" ] || die "--flake is required (try --help)"
[ -n "$host" ]  || die "--host is required (try --help)"

if [ ! -e "$flake" ] && ! printf '%s' "$flake" | grep -qE '^[a-z]+:'; then
  die "--flake path does not exist: $flake"
fi

# detect platform

case "$(uname -s)" in
  Darwin) platform=darwin ;;
  Linux)  platform=nixos ;;
  *)      die "unsupported platform: $(uname -s)" ;;
esac

log "platform: $platform"
log "flake:    $flake"
log "host:     $host"
[ "$platform" = nixos ] && log "root:     $root"

# validate the host exists in the flake

# Ask the flake for the configuration names directly.
config_attr="nixosConfigurations"
[ "$platform" = darwin ] && config_attr="darwinConfigurations"

log "checking for $config_attr.$host in $flake"
config_names="$(nix eval --json "$flake#$config_attr" --apply "builtins.attrNames")" \
  || die "could not evaluate $flake#$config_attr"
if ! printf '%s' "$config_names" | grep -qF "\"$host\""; then
  die "host \"$host\" not found in $config_attr of $flake (available: $config_names)"
fi

# install

case "$platform" in
  nixos)
    [ -d "$root" ] || die "--root does not exist: $root"
    if command -v mountpoint >/dev/null 2>&1 && ! mountpoint -q "$root"; then
      log "warning: $root does not look like a mountpoint; continuing anyway"
    fi
    # Requires the flake to be reachable from the installer environment.
    log "installing NixOS configuration \"$host\" into $root"
    run nixos-install --flake "$flake#$host" --root "$root"
    log "done. The system will boot into \"$host\" on next restart."
    ;;

  darwin)
    if ! command -v nix >/dev/null 2>&1; then
      die "nix is not installed; install it first (https://nixos.org/download)"
    fi
    log "switching Darwin configuration \"$host\""
    run nix run nix-darwin -- switch --flake "$flake#$host"
    log "done."
    ;;
esac
