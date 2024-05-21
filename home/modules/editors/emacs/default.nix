{ inputs, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.emacs;
  emacs = with pkgs; if stdenv.isDarwin then pkgs.emacsMacport else emacsPgtk;
  emacsGcc =
    if pkgs.stdenv.isDarwin then
      pkgs.emacs-git.overrideAttrs
        (old: {
          buildInputs = old.buildInputs ++ (with pkgs; [
            darwin.apple_sdk.frameworks.CoreFoundation
            darwin.apple_sdk.frameworks.WebKit
          ]);
        })
    else
      pkgs.emacsPgtkGcc;
in
{
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
