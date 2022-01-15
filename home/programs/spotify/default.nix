{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ spotify-tui ];

  xdg.configFile."spotify-tui/config.yml".source = ./spotify-tui.yml;
}
