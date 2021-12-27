{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.emacs;
  withPatches = pkg: patches: pkg.overrideAttrs (attrs: { inherit patches; });
  patches = path:
    with builtins;
    (map (n: path + ("/" + n))
      (filter (n: match ".*\\.patch" n != null) (attrNames (readDir path))));

  emacsMacport = withPatches pkgs.emacsMacport (patches ./patches/emacsMacport);
  emacs = with pkgs; if stdenv.isDarwin then emacsMacport else emacsPgtk;
  emacsGcc = ((if pkgs.stdenv.isDarwin then
    pkgs.emacsGcc
  else
    pkgs.emacsPgtkGcc).overrideAttrs (old:
      with pkgs; {
        buildInputs = old.buildInputs ++ lib.optionals stdenv.isDarwin [
          pkgs.darwin.apple_sdk.frameworks.CoreFoundation
          pkgs.darwin.apple_sdk.frameworks.WebKit
        ];
      })).override { withXwidgets = true; };
in {
  config = mkIf cfg.enable {
    programs = {
      emacs = {
        package = emacs;
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
