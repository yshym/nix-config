{ config, lib, pkgs, ... }:

{
  services.redshift = {
    enable = true;
    package = pkgs.redshift-wlr;
    provider = "geoclue2";
    temperature = {
      day = 7700;
      night = 5500;
    };
  };
}
