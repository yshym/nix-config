{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # entertaiment
    playerctl
  ];
}
