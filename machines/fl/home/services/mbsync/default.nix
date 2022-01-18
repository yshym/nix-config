{ config, lib, pkgs, ... }:

{
  services.mbsync = {
    enable = true;
  };

  home.file.".mbsyncrc".source = ./mbsyncrc;
}
