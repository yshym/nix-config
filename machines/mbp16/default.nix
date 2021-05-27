{ config, lib, pkgs, ... }:

{
  imports = [ ../../platforms/darwin ];

  networking.hostName = "mbp16";

  services = {
    postgresql = {
      enable = true;
      package = pkgs.postgresql_12;
    };
  };
}
