{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # media
    pavucontrol
    playerctl

    sortdir
  ];
}
