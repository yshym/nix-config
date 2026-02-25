{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.unstable.ncspot ];

  xdg.configFile."ncspot/config.toml".source = ./config.toml;
}
