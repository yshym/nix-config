{ config, lib, pkgs, ... }:

let
  cfg = config.wayland.windowManager.sway;
  darkBlue = "#6272a4";
in {
  config = {
    wayland.windowManager.sway = {
      enable = true;
      systemdIntegration = true;
      xwayland = false;
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
      config = {
        fonts = {
          names = [ "Fira Code" ];
          size = 8.0;
        };

        window = {
          titlebar = false;
          border = 3;
          commands = [{
            criteria = { title = "Firefox — Sharing Indicator"; };
            command = "floating enable";
          }];
        };

        focus = { followMouse = true; };

        assigns = {
          "1" = [{ app_id = "firefox"; }];
          "2" = [{ app_id = "emacs"; }];
          "3" = [{ app_id = "telegramdesktop"; }];
        };

        modifier = "Mod4";

        colors = {
          focused = {
            border = "#353439";
            background = darkBlue;
            text = "#f8f8f2";
            indicator = darkBlue;
            childBorder = darkBlue;
          };
        };

        bars = [ ];

        startup = [{ command = "import-gsettings"; }];

        gaps = {
          inner = 5;
          outer = 3;
          smartGaps = true;
        };

        menu = "wofi --show=drun --lines=10";

        terminal = "alacritty";

        input = {
          "1:1:AT_Translated_Set_2_keyboard" = {
            xkb_layout = "us,ru,ua";
            xkb_options = "grp:alt_shift_toggle";
          };
          "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
            dwt = "enabled";
            natural_scroll = "enabled";
            pointer_accel = "0";
            scroll_factor = "0.5";
            tap = "enabled";
            tap_button_map = "lrm";
          };
        };

        output = let bg = "~/.local/share/wallpaper.png stretch";
        in {
          "eDP-1" = { bg = bg; };
          "DP-4" = { bg = bg; };
        };

        seat = {
          "seat0" = {
            hide_cursor = "3000";
            xcursor_theme = "Bibata_Oil 20";
          };
        };

        keybindings = {
          # start a terminal
          "${cfg.config.modifier}+Return" = "exec ${cfg.config.terminal}";

          # control screen brightness
          "XF86MonBrightnessUp" = "exec light -A 5";
          "XF86MonBrightnessDown" = "exec light -U 5";

          # control media volume
          "XF86AudioMute" = "exec pamixer --toggle-mute";
          "XF86AudioRaiseVolume" = "exec pamixer -i 5";
          "XF86AudioLowerVolume" = "exec pamixer -d 5";

          # kill focused window
          "${cfg.config.modifier}+Shift+q" = "kill";

          # start a menu app
          "${cfg.config.modifier}+d" = "exec ${cfg.config.menu}";

          # make a screenshot
          "${cfg.config.modifier}+F11" = "exec ~/.local/platform/bin/maim.sh";
          "${cfg.config.modifier}+Shift+F11" =
            "exec ~/.local/platform/bin/maim.sh -s";

          # change focus
          "${cfg.config.modifier}+${cfg.config.left}" = "focus left";
          "${cfg.config.modifier}+${cfg.config.down}" = "focus down";
          "${cfg.config.modifier}+${cfg.config.up}" = "focus up";
          "${cfg.config.modifier}+${cfg.config.right}" = "focus right";
          "${cfg.config.modifier}+Left" = "focus left";
          "${cfg.config.modifier}+Down" = "focus down";
          "${cfg.config.modifier}+Up" = "focus up";
          "${cfg.config.modifier}+Right" = "focus right";

          # move focused window
          "${cfg.config.modifier}+Shift+${cfg.config.left}" = "move left";
          "${cfg.config.modifier}+Shift+${cfg.config.down}" = "move down";
          "${cfg.config.modifier}+Shift+${cfg.config.up}" = "move up";
          "${cfg.config.modifier}+Shift+${cfg.config.right}" = "move right";
          "${cfg.config.modifier}+Shift+Left" = "move left";
          "${cfg.config.modifier}+Shift+Down" = "move down";
          "${cfg.config.modifier}+Shift+Up" = "move up";
          "${cfg.config.modifier}+Shift+Right" = "move right";

          # split workspace
          "${cfg.config.modifier}+b" = "splith";
          "${cfg.config.modifier}+v" = "splitv";

          # enter fullscreen mode for the focused container
          "${cfg.config.modifier}+f" = "fullscreen toggle";

          # focus the parent container
          "${cfg.config.modifier}+a" = "focus parent";

          # change container layout
          "${cfg.config.modifier}+s" = "layout stacking";
          "${cfg.config.modifier}+w" = "layout tabbed";
          "${cfg.config.modifier}+e" = "layout toggle split";

          # toggle tiling / floating
          "${cfg.config.modifier}+Shift+space" = "floating toggle";

          # change focus between tiling / floating windows
          "${cfg.config.modifier}+space" = "focus mode_toggle";

          # focus workspace
          "${cfg.config.modifier}+1" = "workspace 1";
          "${cfg.config.modifier}+2" = "workspace 2";
          "${cfg.config.modifier}+3" = "workspace 3";
          "${cfg.config.modifier}+4" = "workspace 4";
          "${cfg.config.modifier}+5" = "workspace 5";
          "${cfg.config.modifier}+6" = "workspace 6";
          "${cfg.config.modifier}+7" = "workspace 7";
          "${cfg.config.modifier}+8" = "workspace 8";
          "${cfg.config.modifier}+9" = "workspace 9";

          # move focused container to workspace
          "${cfg.config.modifier}+Shift+1" = "move container to workspace 1";
          "${cfg.config.modifier}+Shift+2" = "move container to workspace 2";
          "${cfg.config.modifier}+Shift+3" = "move container to workspace 3";
          "${cfg.config.modifier}+Shift+4" = "move container to workspace 4";
          "${cfg.config.modifier}+Shift+5" = "move container to workspace 5";
          "${cfg.config.modifier}+Shift+6" = "move container to workspace 6";
          "${cfg.config.modifier}+Shift+7" = "move container to workspace 7";
          "${cfg.config.modifier}+Shift+8" = "move container to workspace 8";
          "${cfg.config.modifier}+Shift+9" = "move container to workspace 9";

          # move the currently focused window to the scratchpad
          "${cfg.config.modifier}+Shift+minus" = "move scratchpad";
          # cycle through scratchpad windows
          "${cfg.config.modifier}+minus" = "scratchpad show";

          "${cfg.config.modifier}+Shift+c" = "reload";
          "${cfg.config.modifier}+Shift+e" =
            "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          "${cfg.config.modifier}+r" = "mode resize";
        };

        modes = {
          resize = {
            "${cfg.config.left}" = "resize shrink width 10 px";
            "${cfg.config.down}" = "resize grow height 10 px";
            "${cfg.config.up}" = "resize shrink height 10 px";
            "${cfg.config.right}" = "resize grow width 10 px";
            "Left" = "resize shrink width 10 px";
            "Down" = "resize grow height 10 px";
            "Up" = "resize shrink height 10 px";
            "Right" = "resize grow width 10 px";
            "Escape" = "mode default";
            "Return" = "mode default";
          };
        };
      };
    };

    home = {
      file.".local/share/wallpaper.png".source = ./wallpaper.png;
      packages = with lib;
        with pkgs;
        mkIf cfg.enable [
          # supporting libraries
          libnotify
          qt5.qtwayland

          # sway components
          swaybg # required by sway for controlling desktop wallpaper
          swayidle # used for controlling idle timeouts and triggers (screen locking, etc)
          swaylock # used for locking Wayland sessions

          # wayland programs
          gebaar-libinput # libinput gestures utility
          grim # screen image capture
          imv # image viewer
          slurp # region selection utility
          wl-clipboard # clipboard manipulation tool
          ydotool # xdotool for wayland

          pamixer # audio mixer
        ];
    };
  };
}
