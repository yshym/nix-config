{ pkgs, ... }:

{
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # open application
      cmd - d : open-app

      # open terminal
      alt - return : open -n -a "Alacritty"

      # make a screenshot
      alt - p : screenshot
      shift + alt - p : screenshot -s

      # emacs-everywhere
      alt - e : doom everywhere

      # focus bsp windows
      alt - h : yabai -m window --focus west
      alt - j : "$HOME/.config/yabai/focus_south.sh"
      alt - k : "$HOME/.config/yabai/focus_north.sh"
      alt - l : yabai -m window --focus east

      # swap window
      shift + alt - h : yabai -m window --swap west
      shift + alt - j : yabai -m window --swap south
      shift + alt - k : yabai -m window --swap north
      shift + alt - l : yabai -m window --swap east

      # move window
      shift + cmd - h : yabai -m window --warp west
      shift + cmd - j : yabai -m window --warp south
      shift + cmd - k : yabai -m window --warp north
      shift + cmd - l : yabai -m window --warp east

      # focus desktops
      alt - 1 : yabai -m space --focus 1
      alt - 2 : yabai -m space --focus 2
      alt - 3 : yabai -m space --focus 3
      alt - 4 : yabai -m space --focus 4
      alt - 5 : yabai -m space --focus 5
      alt - 6 : yabai -m space --focus 6
      alt - 7 : yabai -m space --focus 7
      alt - 8 : yabai -m space --focus 8
      alt - 9 : yabai -m space --focus 9
      alt - 0 : yabai -m space --focus 10

      # send window to desktop and follow focus
      shift + alt - x : yabai -m window --space recent && yabai -m space --focus recent
      shift + alt - z : yabai -m window --space prev && yabai -m space --focus prev
      shift + alt - c : yabai -m window --space next && yabai -m space --focus next
      shift + alt - 1 : yabai -m window --space 1 && yabai -m space --focus 1
      shift + alt - 2 : yabai -m window --space 2 && yabai -m space --focus 2
      shift + alt - 3 : yabai -m window --space 3 && yabai -m space --focus 3
      shift + alt - 4 : yabai -m window --space 4 && yabai -m space --focus 4
      shift + alt - 5 : yabai -m window --space 5 && yabai -m space --focus 5
      shift + alt - 6 : yabai -m window --space 6 && yabai -m space --focus 6
      shift + alt - 7 : yabai -m window --space 7 && yabai -m space --focus 7
      shift + alt - 8 : yabai -m window --space 8 && yabai -m space --focus 8
      shift + alt - 9 : yabai -m window --space 9 && yabai -m space --focus 9
      shift + alt - 0 : yabai -m window --space 10 && yabai -m space --focus 10

      # toggle window zoom
      alt - w : yabai -m window --toggle zoom-fullscreen

      # toggle window split type
      alt - t : yabai -m window --toggle split

      # rotate tree
      alt - r : yabai -m space --rotate 90

      # mirror tree y-axis
      alt - y : yabai -m space --mirror y-axis

      # mirror tree x-axis
      alt - x : yabai -m space --mirror x-axis

      # toggle stack
      shift + alt - s : "$HOME/.config/yabai/toggle_stack.sh"

      # set horizontal splitting direction
      alt - s : yabai -m window --insert east

      # set vertical splitting direction
      alt - v : yabai -m window --insert south

      # restart yabai
      shift + alt - r : launchctl kickstart -k "gui/$UID/org.nixos.skhd" && \
            launchctl kickstart -k "gui/$UID/org.nixos.yabai"
    '';
  };
}
