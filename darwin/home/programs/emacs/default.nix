{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.emacs;
  withPatches = pkg: patches: pkg.overrideAttrs (attrs: { inherit patches; });

  patchesPath = ./patches;
  myEmacs = with builtins;
    withPatches pkgs.emacs
      (map (n: patchesPath + ("/" + n)) (filter (n: match ".*\\.patch" n != null) (attrNames (readDir patchesPath))));
  myEmacsGcc = (pkgs.emacsGcc.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
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
          "https://github.com/nix-community/emacs-overlay/archive/f98b64c94f1302d444250f41442c63d1d16f0525.tar.gz";
      }))
    ];

    programs = {
      emacs = {
        package = if cfg.useHead then pkgs.emacsGit else myEmacs;
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
