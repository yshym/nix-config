{ config, lib, pkgs, ... }:

{
  imports = [ ../../platforms/darwin ./home.nix ];

  services = {
    postgresql = {
      enable = true;
      dataDir = "/usr/local/var/postgres";
    };
  };
}
