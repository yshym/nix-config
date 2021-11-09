{ config, lib, pkgs, ... }:

{
  imports = [ ./kanshi ./mako ./waybar ];

  programs = {
    # TODO: Set up gpg key
    # git.gpgKey = "";
  };
}
