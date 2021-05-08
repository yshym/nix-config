{ config, lib, pkgs, ... }:

{
  xdg.configFile."spotifyd/spotifyd.conf".source = ./spotifyd.conf;
  xdg.configFile."spotify-tui/config.yml".source = ./spotify-tui.yml;
}
