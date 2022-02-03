{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.wofi ];
  xdg.configFile."wofi/style.css".source = ./style.css;
}
