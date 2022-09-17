{ pkgs, ... }:

{
  xdg.configFile = {
    "yabai/padding".source = ./padding;
    "yabai/toggle_stack.sh".source = ./toggle_stack.sh;
    "yabai/focus_south.sh".source = ./focus_south.sh;
    "yabai/focus_north.sh".source = ./focus_north.sh;
  };
}
