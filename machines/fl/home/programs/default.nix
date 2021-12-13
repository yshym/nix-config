{ config, lib, pkgs, ... }:

{
  imports = [ ./mako ./telegram ./waybar ./wofi ];

  programs = {
    firefox.package = pkgs.firefox-wayland;
    git.gpgKey = "4B0D9393F36E588A";
  };
}
