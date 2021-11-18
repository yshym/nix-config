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
  config = mkIf cfg.enable {
    programs = {
      emacs = {
        package = emacsMacport;
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
      ".authinfo.gpg".source = ./authinfo.gpg;
      ".doom.d" = {
        source = ./doom.d;
        recursive = true;
      };
    };
  };
}
