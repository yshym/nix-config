{ inputs, config, lib, pkgs, ... }:

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
  emacsGcc = if pkgs.stdenv.isDarwin then
    pkgs.emacsGcc.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ (with pkgs; [
        darwin.apple_sdk.frameworks.CoreFoundation
        darwin.apple_sdk.frameworks.WebKit
      ]);
    })
  else
    pkgs.emacsPgtkGcc;
in {
  config = mkIf cfg.enable {
    programs = {
      emacs.package = emacsGcc;
      zsh = {
        envExtra = ''
          export PATH="$HOME/.emacs.d/bin:$PATH"
        '';
        sessionVariables.EDITOR = "emacsclient";
      };
    };

    home = {
      file = {
        ".authinfo.gpg".source = ./authinfo.gpg;
        ".doom.d" = {
          source = ./doom.d;
          recursive = true;
        };
      };
    };
  };
}
