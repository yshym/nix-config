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
  emacsPkg = with pkgs; if stdenv.isDarwin then
    emacs-pgtk.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        # Fix window role for tiling window managers (e.g., yabai)
        (fetchpatch {
          url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/fix-window-role.patch";
          sha256 = "sha256-+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
        })
        # Enable rounded, undecorated windows
        (fetchpatch {
          url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/round-undecorated-frame.patch";
          sha256 = "sha256-uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
        })
        # Sync with macOS light/dark mode
        # (fetchpatch {
        #   url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/system-appearance.patch";
        #   sha256 = "sha256-oM6fXdXCWVcBnNrzXmF0ZMdp8j0pzkLE66WteeCutv8=";
        # })
      ];
    })
  else
    emacs-pgtk;
in
{
  options.modules.editors.emacs = {
    enable = mkEnableOption "Emacs";
  };

  config = mkIf cfg.enable {
    home = {
      programs = {
        emacs = {
          enable = true;
          package = emacsPkg;
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
    user.packages = with pkgs; [
      coreutils-prefixed
      fd
      ripgrep
      symbola
      sqlite
      wordnet
    ];
  };
}
