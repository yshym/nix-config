{ config, lib, pkgs, ... }:

let
  cfg = config.wayland.windowManager.sway;
  mod = cfg.config.modifier;
  left = cfg.config.left;
  right = cfg.config.right;
  up = cfg.config.up;
  down = cfg.config.down;
  darkBlue = "#6272a4";
in
{
  config = {
    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;
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
        export WLR_DRM_NO_MODIFIERS=1
        export NIXOS_OZONE_WL=1
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
          "3" = [{ app_id = "telegramdesktop"; } { title = "^Slack"; }];
        };

        modifier = "Mod1";

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
            xkb_options = "grp:win_space_toggle";
          };
          "12951:6505:ZSA_Technology_Labs_Moonlander_Mark_I" = {
            xkb_layout = "us,ru,ua";
            xkb_options = "grp:win_space_toggle";
          };
          "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
            dwt = "enabled";
            natural_scroll = "disabled";
            pointer_accel = "0";
            scroll_factor = "0.5";
            tap = "enabled";
            tap_button_map = "lrm";
          };
          "5426:166:Razer_Razer_Viper_V2_Pro_Mouse" = {
            pointer_accel = "0";
            scroll_factor = "0.5";
          };
        };

        output =
          let bg = "~/.local/share/wallpaper.png stretch";
          in
          {
            "eDP-1" = { bg = bg; };
            "DP-1" = { bg = bg; };
          };

        seat = {
          "seat0" = {
            hide_cursor = "3000";
            xcursor_theme = "Bibata-Modern-Classic 20";
          };
        };

        keybindings = {
          # start a terminal
          "${mod}+Return" = "exec ${cfg.config.terminal}";

          # control screen brightness
          "XF86MonBrightnessUp" = "exec light -A 5";
          "XF86MonBrightnessDown" = "exec light -U 5";

          # control media volume
          "XF86AudioMute" = "exec pamixer --toggle-mute";
          "XF86AudioRaiseVolume" = "exec pamixer -i 5";
          "XF86AudioLowerVolume" = "exec pamixer -d 5";

          # kill focused window
          "${mod}+q" = "kill";

          # start a menu app
          "${mod}+d" = "exec ${cfg.config.menu}";

          # make a screenshot
          "Print" = "exec ~/.local/platform/bin/maim.sh";
          "Shift+Print" = "exec ~/.local/platform/bin/maim.sh -s";

          # change focus
          "${mod}+${left}" = "focus left";
          "${mod}+${right}" = "focus right";
          "${mod}+${up}" = "focus up";
          "${mod}+${down}" = "focus down";
          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          # move focused window
          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${right}" = "move right";
          "${mod}+Shift+${up}" = "move up";
          "${mod}+Shift+${down}" = "move down";
          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          # split workspace
          "${mod}+b" = "splith";
          "${mod}+v" = "splitv";

          # enter fullscreen mode for the focused container
          "${mod}+f" = "fullscreen toggle";

          # focus the parent container
          "${mod}+a" = "focus parent";

          # change container layout
          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          "${mod}+e" = "layout toggle split";

          # toggle tiling / floating
          "${mod}+Shift+space" = "floating toggle";

          # change focus between tiling / floating windows
          "${mod}+space" = "focus mode_toggle";

          # focus workspace
          "${mod}+1" = "workspace 1";
          "${mod}+2" = "workspace 2";
          "${mod}+3" = "workspace 3";
          "${mod}+4" = "workspace 4";
          "${mod}+5" = "workspace 5";
          "${mod}+6" = "workspace 6";
          "${mod}+7" = "workspace 7";
          "${mod}+8" = "workspace 8";
          "${mod}+9" = "workspace 9";

          # move focused container to workspace
          "${mod}+Shift+1" = "move container to workspace 1";
          "${mod}+Shift+2" = "move container to workspace 2";
          "${mod}+Shift+3" = "move container to workspace 3";
          "${mod}+Shift+4" = "move container to workspace 4";
          "${mod}+Shift+5" = "move container to workspace 5";
          "${mod}+Shift+6" = "move container to workspace 6";
          "${mod}+Shift+7" = "move container to workspace 7";
          "${mod}+Shift+8" = "move container to workspace 8";
          "${mod}+Shift+9" = "move container to workspace 9";

          # move the currently focused window to the scratchpad
          "${mod}+Shift+minus" = "move scratchpad";
          # cycle through scratchpad windows
          "${mod}+minus" = "scratchpad show";

          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+e" =
            "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          "${mod}+r" = "mode resize";
        };

        modes = {
          resize = {
            "${left}" = "resize shrink width 10 px";
            "${right}" = "resize grow width 10 px";
            "${up}" = "resize shrink height 10 px";
            "${down}" = "resize grow height 10 px";
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
      packages = with pkgs;
        lib.mkIf cfg.enable [
          # supporting libraries
          glib
          libnotify
          qt5.qtwayland
          qt6.qtwayland

          # sway components
          swaybg # required by sway for controlling desktop wallpaper

          # wayland programs
          gebaar-libinput # libinput gestures utility
          grim # screen image capture
          imv # image viewer
          slurp # region selection utility
          wl-clipboard # clipboard manipulation tool
          ydotool # fake keyboard/mouse input

          pamixer # audio mixer
        ];
    };
  };
}
