{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.editors.emacs;
  emacs30-nixpkgs = import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/0919966ec74f9e402c5ed442d938f12980c57fc2.tar.gz";
      sha256 = "1zq8yvbkf0p2qni5y0kpf3dqx33p0mmp2qm991qglwfxxs64rxy3";
    })
    { system = pkgs.stdenv.system; };
  emacs = with pkgs;
    if stdenv.isDarwin then
      emacs30-nixpkgs.emacs30.override { withNativeCompilation = true; }
    else
      emacs-git-pgtk;
in
{
  options.modules.editors.emacs = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    home = {
      programs = {
        emacs = {
          enable = true;
          package = emacs;
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
    user.packages = with pkgs; [ coreutils-prefixed fd ripgrep symbola ];
  };
}
