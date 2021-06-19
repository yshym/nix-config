{ pkgs, ... }:

let padding = 10;
in {
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      # mouse_follows_focus = "on";
      # focus_follows_mouse = "autoraise";
      window_shadow = "off";
      window_placement = "second_child";
      # window_border = "on";
      # window_border_width = 5;
      # active_window_border_color = "0xffa35763";
      # normal_window_border_color = "0xff353c54";
      insert_feedback_color = "0xaa7c5c9c";
      auto_balance = "off";
      split_ratio = 0.50;
      window_gap = 7;
      layout = "bsp";
      top_padding = padding;
      bottom_padding = padding;
      left_padding = padding;
      right_padding = padding;
    };
    extraConfig = ''
      # external status bar
      # SPACEBAR_HEIGHT=$(spacebar -m config height)
      # yabai -m config external_bar all:$SPACEBAR_HEIGHT:0

      # mission-control desktop labels
      yabai -m space 1 --label web
      yabai -m space 2 --label code
      yabai -m space 3 --label social
      yabai -m space 4 --label media

      # window rules
      yabai -m rule --add app="^Firefox$" space=web
      yabai -m rule --add app="^Emacs$" space=code manage=on
      yabai -m rule --add app="^Telegram$" space=social manage=on
      yabai -m rule --add app="^Slack$" space=social
      yabai -m rule --add app="^Discord$" space=social
      yabai -m rule --add app="^Zoom$" space=social manage=on
      yabai -m rule --add app="^Transmission$" space=media
      yabai -m rule --add app="^Spotify$" space=media manage=on
      yabai -m rule --add app="^mpv$" space=media manage=on
      yabai -m rule --add app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
      yabai -m rule --add app="^Spotlight$" layer=above manage=off
      yabai -m rule --add app="^Stickies$" manage=off
      yabai -m rule --add app="^System Preferences$" manage=off
      yabai -m rule --add app="^choose$" manage=off

      # signals
      yabai -m signal --add event=window_destroyed action="yabai -m query --windows --window &> /dev/null || yabai -m window --focus mouse"
      yabai -m signal --add event=application_terminated action="yabai -m query --windows --window &> /dev/null || yabai -m window --focus mouse"
    '';
  };
}
