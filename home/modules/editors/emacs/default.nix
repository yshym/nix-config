{ inputs, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.emacs;
  emacs29 = (import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/c434383f2a4866a7c674019b4cdcbfc55db3c4ab.tar.gz";
      sha256 = "072c46gnmzyphbm1y5iq75k9x4d9g59n4jyivmlg63j0w022v2mb";
    })
    { system = pkgs.stdenv.system; }).emacs29;
  # emacsGit is a legacy package name
  emacs-git = pkgs.emacsGit;
  emacs = if pkgs.stdenv.isDarwin then emacs29 else pkgs.emacsPgtkGcc;
  # emacs =
  #   if pkgs.stdenv.isDarwin then
  #     emacs-git.overrideAttrs
  #       (old: {
  #         buildInputs = old.buildInputs ++ (with pkgs; [
  #           darwin.apple_sdk.frameworks.CoreFoundation
  #           darwin.apple_sdk.frameworks.WebKit
  #         ]);
  #       })
  #   else
  #     pkgs.emacsPgtkGcc;
in
{
  config = mkIf cfg.enable {
    programs = {
      emacs.package = emacs;
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
