{ config, lib, pkgs, ... }:

let
  cfg = config.wayland.windowManager.hyprland;

  wofiCmd = "wofi --show=drun --lines=10 --prompt=\"Run:\"";

  darkBlue = "#6272a4";
  purple = "#BD93F9";
  pastelRed = "#ff9e99";
  hexToRGB = hex: "rgb(${lib.strings.removePrefix "#" hex})";
  hexToRGBA = hex: a: "rgba(${lib.strings.removePrefix "#" hex}${a})";
  toGradient = hex1: hex2: "${hexToRGB hex1} ${hexToRGB hex2} 45deg";
in
{
  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd = {
        enable = true;
        variables = ["--all"];
      };
      xwayland.enable = true;
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      plugins = with pkgs; [ hy3 ];
      settings = {
        # exec-once = [
        #   (restartBin "waybar")
        #   (restartBin "kanshi")
        # ];

        animations.enabled = false;

        misc.font_family = "Fira Code";
        group.groupbar.font_size = 12;

        decoration = {
          rounding = 12;
        };

        plugin.hy3.tabs."col.active" = hexToRGBA "${darkBlue}" "40";
        plugin.hy3.tabs."col.active.border" = hexToRGB darkBlue;

        general = {
          layout = "hy3";
          gaps_in = 3;
          gaps_out = 5;
          border_size = 3;
          "col.active_border" = toGradient darkBlue purple;
        };

        input = {
          mouse_refocus = true;
        };

        cursor.no_warps = true;

        device = [
          {
            name = "at-translated-set-2-keyboard";
            kb_layout = "us,ru,ua";
            kb_options = "grp:win_space_toggle";
          }
          {
            name = "zsa-technology-labs-moonlander-mark-i";
            kb_layout = "us,ru,ua";
            kb_options = "grp:win_space_toggle,altwin:swap_alt_win";
          }
          {
            name = "pixa3854:00-093a:0274-touchpad";
            disable_while_typing = true;
            natural_scroll = false;
            accel_profile = "flat";
            scroll_factor = 0.5;
            tap-to-click = true;
            clickfinger_behavior = false;
          }
          {
            name = "apple-internal-keyboard-/-trackpad";
            natural_scroll = false;
            accel_profile = "flat";
            scroll_factor = 0.5;
            kb_layout = "us,ru,ua";
            kb_options = "grp:win_space_toggle,altwin:swap_alt_win";
          }
          {
            name = "razer-razer-viper-v2-pro-mouse";
            accel_profile = "flat";
            scroll_factor = 0.5;
          }
          {
            name = "logitech-usb-receiver";
            sensitivity = -0.5;
            scroll_factor = 0.5;
          }
        ];

        "$mod" = "SUPER";

        bindm = [
          # mouse movements
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
          "$mod ALT, mouse:272, resizewindow"
        ];

        bind = [
          # terminal
          "$mod, RETURN, exec, alacritty"

          # app menu
          "$mod, d, exec, pkill wofi; ${wofiCmd}"

          # kill window
          "$mod, q, killactive"

          # fullscreen window
          "$mod, f, fullscreen"

          # maximize window
          "$mod, w, fullscreen, 1"

          # toggle tabs
          "$mod, t, hy3:changegroup, toggletab"

          # make a screenshot
          "$mod, p, exec, ~/.local/platform/bin/maim.sh"
          "$mod SHIFT, p, exec, ~/.local/platform/bin/maim.sh -s"

          # split type
          "$mod, b, hy3:makegroup, v"
          "$mod, v, hy3:makegroup, h"
        ] ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList
            (i:
              let ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        ) ++ (
          # windows
          # binds $mod + [shift +] {hjkl} to {focus,move} windows {}
          builtins.concatLists (lib.zipListsWith
            (d: c: [
              "$mod, ${c}, hy3:movefocus, ${d}"
              "$mod SHIFT, ${c}, hy3:movewindow, ${d}"
            ])
            (lib.strings.stringToCharacters "ldur")
            (lib.strings.stringToCharacters "hjkl"))
        );

        bindel = [
          # screen brightness
          ", XF86MonBrightnessUp, exec, light -A 5"
          ", XF86MonBrightnessDown, exec, light -U 5"

          # media volume
          ", XF86AudioMute, exec, pamixer --toggle-mute"
          ", XF86AudioRaiseVolume, exec, pamixer -i 5"
          ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ];

        # workspace = [
        #   # Disable gaps for a single tiling window
        #   "w[tv1], gapsin:0, gapsout:0"
        # ];

        windowrule = [
          # Disable border for a single tiling window
          "border_size 0, match:float 0, match:workspace w[tv1]"
          "rounding 0, match:float 0, match:workspace w[tv1]"

          # Assign windows to workspaces
          "workspace 1, match:class ^brave-browser$"
          "workspace 2, match:class ^emacs$"
          "workspace 3, match:title ^Telegram"
          "workspace 3, match:title ^Slack"
        ];
      };
    };

    home = lib.mkIf cfg.enable {
      packages = with pkgs; [
        # supporting libraries
        glib
        libnotify
        qt5.qtwayland
        qt6.qtwayland

        # wayland programs
        gebaar-libinput # libinput gestures utility
        grim            # screen image capture
        imv             # image viewer
        slurp           # region selection utility
        wl-clipboard    # clipboard manipulation tool
        ydotool         # fake keyboard/mouse input

        wiremix         # audio mixer
        pamixer
        pavucontrol
      ];
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        DISABLE_QT5_COMPAT = "0";
        QT_QPA_PLATFORM = "wayland;xcb";
        GDK_BACKEND = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        # QT_QPA_PLATFORMTHEME = "qt5ct";
        MOZ_ENABLE_BACKEND = "1";
        XDG_SESSION_TYPE = "wayland";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
      };
    };

    xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-wlr cfg.portalPackage ];
  };
}
