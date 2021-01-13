{ pkgs, ... }:

{
  xdg.configFile = {
    "yabai/padding".source = ./padding;
    "yabai/toggle_stack.sh".source = ./toggle_stack.sh;
  };
}
