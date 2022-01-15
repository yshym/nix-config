{ config, lib, pkgs, ... }:

{
  xdg.configFile."spotifyd/spotifyd.conf".source = ./spotifyd.conf;
}
