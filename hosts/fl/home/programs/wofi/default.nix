{ config, lib, pkgs, ... }:

# TODO Create wofi module
{
  home.packages = [ pkgs.wofi ];
  xdg.configFile."wofi/style.css".source = ./style.css;
}
