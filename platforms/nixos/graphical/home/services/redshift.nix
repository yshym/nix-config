{ config, lib, pkgs, ... }:

{
  services.gammastep = {
    enable = true;
    provider = "geoclue2";
    temperature = {
      day = 7700;
      night = 5500;
    };
  };
}
