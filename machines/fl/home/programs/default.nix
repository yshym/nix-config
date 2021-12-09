{ config, lib, pkgs, ... }:

{
  imports = [ ./mako ./rofi ./telegram ./waybar ];

  programs = {
    firefox.package = pkgs.firefox-wayland;
    git.gpgKey = "4B0D9393F36E588A";
  };
}
