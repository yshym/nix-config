#!/usr/bin/env janet
# Usage: h CMD [ARG...]
# Commands:
#   build|b       Build a Nix expression
#   check|c       Check whether the flake evaluates and run its tests
#   rebuild|rb    Rebuild the current system's flake
#   search|s      Search nixpkgs for a package
#   shell|sh      Run a shell with the specified packages available
#   update|u      Update flake lock file
# Options:
#   --help|-h     Show help

(use ./cmd)
(use sh)

(defn- darwin? []
  (= (os/which) :macos))

(defn- flake-path []
  (if (darwin?)
    (string (os/getenv "HOME") "/.nixpkgs")
    "/etc/nixos"))

(defn- nixos-rebuild []
  (if (darwin?) "darwin-rebuild" "nixos-rebuild"))

(defn- hostname []
  ($<_ hostname -s))

(defcmd help []
  (print (help)))

(defcmd build [&opt rest]
  (default rest @[])
  ($ nix build ,;rest))

(defcmd check [&opt path --impure impure?]
  ($ nix flake check ,(or path (flake-path))
        ,;(if impure? ["--impure"] [])))

(defcmd rebuild [&opt rest]
  (default rest @[])
  ($ sudo ,(nixos-rebuild) switch --flake
          ,(string (flake-path) "#" (hostname))
          ,;rest))

(defcmd search [package]
  ($ nix search nixpkgs ,package))

(defcmd shell [package]
  ($ nix shell ,(string "nixpkgs#" package)))

(defcmd update [&opt rest]
  (default rest @[])
  ($ nix flake update ,;rest))

(defn main [& args]
  (dispatch [[:--help :-h]  (cmd 'help)
             [:build :b]    (cmd 'build)
             [:check :c]    (cmd 'check)
             [:rebuild :rb] (cmd 'rebuild)
             [:search :s]   (cmd 'search)
             [:shell :sh]   (cmd 'shell)
             [:update :u]   (cmd 'update)]
            args))
