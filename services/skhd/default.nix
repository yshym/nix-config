{ pkgs, ... }:

{
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # open terminal
      alt - return : open -a "iTerm"

      # focus bsp windows
      alt - h : yabai -m window --focus west
      alt - j : yabai -m window --focus south
      alt - k : yabai -m window --focus north
      alt - l : yabai -m window --focus east

      # focus stack windows
      ctrl + alt - j : yabai -m window --focus stack.next \
            || yabai -m window --focus stack.first
      ctrl + alt - k : yabai -m window --focus stack.prev \
            || yabai -m window --focus stack.last

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
      shift + ctrl - x : yabai -m window --space recent && yabai -m space --focus recent
      shift + ctrl - z : yabai -m window --space prev && yabai -m space --focus prev
      shift + ctrl - c : yabai -m window --space next && yabai -m space --focus next
      shift + ctrl - 1 : yabai -m window --space 1 && yabai -m space --focus 1
      shift + ctrl - 2 : yabai -m window --space 2 && yabai -m space --focus 2
      shift + ctrl - 3 : yabai -m window --space 3 && yabai -m space --focus 3
      shift + ctrl - 4 : yabai -m window --space 4 && yabai -m space --focus 4
      shift + ctrl - 5 : yabai -m window --space 5 && yabai -m space --focus 5
      shift + ctrl - 6 : yabai -m window --space 6 && yabai -m space --focus 6
      shift + ctrl - 7 : yabai -m window --space 7 && yabai -m space --focus 7
      shift + ctrl - 8 : yabai -m window --space 8 && yabai -m space --focus 8
      shift + ctrl - 9 : yabai -m window --space 9 && yabai -m space --focus 9
      shift + ctrl - 0 : yabai -m window --space 10 && yabai -m space --focus 10

      # toggle window zoom
      alt - w : yabai -m window --toggle zoom-fullscreen

      # toggle window split type
      alt - e : yabai -m window --toggle split

      # rotate tree
      alt - r : yabai -m space --rotate 90

      # mirror tree y-axis
      alt - y : yabai -m space --mirror y-axis

      # mirror tree x-axis
      alt - x : yabai -m space --mirror x-axis

      # toggle stack
      alt - s : "$HOME/.config/yabai/toggle_stack.sh"

      # restart yabai
      shift + alt - r : launchctl kickstart -k "gui/$UID/org.nixos.spacebar" && \
            launchctl kickstart -k "gui/$UID/org.nixos.yabai"
    '';
  };
}
