{ config, lib, pkgs, ... }:

{
  imports = [ ../../platforms/darwin ./home.nix ];

  services = {
    postgresql = {
      enable = true;
      package = pkgs.postgresql_12;
      dataDir = "/usr/local/var/postgres";
    };
  };
}
