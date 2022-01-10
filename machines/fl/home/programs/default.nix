{ config, lib, pkgs, ... }:

{
  imports = [ ./chromium.nix ./mako ./telegram ./waybar ./wluma ./wofi ];

  programs = {
    firefox.package = pkgs.firefox-wayland;
    git.gpgKey = "4B0D9393F36E588A";
    zsh.loginExtra = ''[[ "$(tty)" == /dev/tty1 ]] && sway'';
  };
}
