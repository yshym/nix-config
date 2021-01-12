{ pkgs, ... }:

{
  xdg.configFile = {
    "yabai/padding".source = ./padding;
  };
}
