{ config, lib, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    theme = builtins.readFile ./onedark.rasi;
  };
}
