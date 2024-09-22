{ inputs, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.emacs;
  emacs29-nixpkgs = (import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/c434383f2a4866a7c674019b4cdcbfc55db3c4ab.tar.gz";
      sha256 = "072c46gnmzyphbm1y5iq75k9x4d9g59n4jyivmlg63j0w022v2mb";
    })
    { system = pkgs.stdenv.system; });
  # emacsGit is a legacy package name
  emacs-git = pkgs.emacsGit;
  emacs = if pkgs.stdenv.isDarwin then emacs29-nixpkgs.emacs29 else emacs29-nixpkgs.emacs29-pgtk;
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
