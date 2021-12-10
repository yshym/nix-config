{ config, lib, pkgs, ... }:

{
  imports = [ ./kanshi ];

  services = {
    dropbox = {
      enable = true;
      path = "${config.home.homeDirectory}/dropbox";
    };
  };
}
