{ pkgs, ... }:

{
  xdg.configFile = {
    "yabai/padding".source = ./padding;
    "yabai/toggle_stack.sh".source = ./toggle_stack.sh;
    "yabai/focus_south.sh".source = ./focus_south.sh;
    "yabai/focus_north.sh".source = ./focus_north.sh;
    "yabai/focus_west.sh".source = ./focus_west.sh;
    "yabai/focus_east.sh".source = ./focus_east.sh;
  };
}
