{ config, lib, pkgs, ... }:

{
  imports = [ ./mako ./rofi ./waybar ];

  programs = {
    # TODO: Set up gpg key
    # git.gpgKey = "";
  };
}
