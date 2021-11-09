{ config, lib, pkgs, ... }:

{
  imports = [ ./kanshi ./mako ./rofi ./waybar ];

  programs = {
    # TODO: Set up gpg key
    # git.gpgKey = "";
  };
}
