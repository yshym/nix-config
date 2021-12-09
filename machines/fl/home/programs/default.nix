{ config, lib, pkgs, ... }:

{
  imports = [ ./mako ./rofi ./telegram ./waybar ];

  programs = {
    git.gpgKey = "4B0D9393F36E588A";
  };
}
