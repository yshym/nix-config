{ config, lib, pkgs, ... }:

{
  imports = [ ./mako ./telegram ./waybar ./wluma ./wofi ];

  programs = {
    firefox.package = pkgs.firefox-wayland;
    git.gpgKey = "4B0D9393F36E588A";
    zsh.loginExtra =
      ''[[ "$(tty)" == /dev/tty1 ]] && WLR_DRM_NO_MODIFIERS=1 sway'';
  };
}
