{ config, lib, pkgs, ... }:
with lib;
{
  xdg.configFile = {
    "yabai/yabairc".source = ./yabairc;
    "yabai/padding".source = ./padding;
  };
}
