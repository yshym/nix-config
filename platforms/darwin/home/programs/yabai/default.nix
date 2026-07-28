{ pkgs, ... }:

{
  xdg.configFile = {
    "yabai/padding".source = ./padding;
    "yabai/toggle_stack.sh".source = ./toggle_stack.sh;
    "yabai/focus_space.sh".source = ./focus_space.sh;
    "yabai/focus.sh".source = ./focus.sh;
  };
}
