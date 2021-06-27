{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.emacs;
  withPatches = pkg: patches: pkg.overrideAttrs (attrs: { inherit patches; });
  patches = path:
    with builtins;
    (map (n: path + ("/" + n))
      (filter (n: match ".*\\.patch" n != null) (attrNames (readDir path))));

  emacs = withPatches pkgs.emacs (patches ./patches/emacs27);
  emacsGit = withPatches pkgs.emacsGit (patches ./patches/emacs28);
  emacsMacport = withPatches pkgs.emacsMacport (patches ./patches/emacsMacport);
  emacsGcc =
    ((withPatches pkgs.emacsGcc (patches ./patches/emacs28)).overrideAttrs
      (old: {
        buildInputs = old.buildInputs
          ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
            pkgs.darwin.apple_sdk.frameworks.CoreFoundation
            pkgs.darwin.apple_sdk.frameworks.WebKit
          ];
      })).override { withXwidgets = true; };
in {
  options.programs.emacs = { useHead = mkEnableOption "Build from source"; };

  config = mkIf cfg.enable {
    nixpkgs.overlays = mkIf cfg.enable [
      (import (builtins.fetchTarball {
        url =
          "https://github.com/nix-community/emacs-overlay/archive/729f35be8bf92c25c38f60d7d7281f0927b61f00.tar.gz";
      }))
    ];

    programs = {
      emacs = {
        package = if cfg.useHead then emacsGit else emacsMacport;
        extraPackages = epkgs: [ epkgs.vterm ];
      };
      zsh = {
        envExtra = ''
          export PATH="$HOME/.emacs.d/bin:$PATH"
        '';
        sessionVariables.EDITOR = "emacsclient";
      };
    };

    home.file = {
      ".doom.d" = {
        source = ./.doom.d;
        recursive = true;
      };
    };
  };
}
