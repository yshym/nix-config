{ config, lib, pkgs, ... }:

let cfg = config.wayland.windowManager.sway;
in {
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    xwayland = true;
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
      imports = [ ./options.nix ];

      # TODO: Set up inputs
      # input = {
      #   "<keyboard-name>" = {
      #     xkb_layout = "us,ru,ua";
      #     xkb_options = "grp:alt_shift_toggle";
      #   };
      #   "<touchpad-name>" = {
      #     dwt = "enabled";
      #     tap = "enabled";
      #     tap_button_map = "lrm";
      #     pointer_accel = 0.5;
      #   };
      # };

      # TODO: Set up outputs
      # output = { "<display-name>" = { bg = "<path-to-background> stretch"; }; };

      # TODO: Set up seat
      # seat = { "<seat-name>" = { hide_cursor = "3000"; }; };

      keybindings = {
        # start a terminal
        "${cfg.config.modifier}+Return" = "exec ${cfg.config.terminal}";

        # kill focused window
        "${cfg.config.modifier}+Shift+q" = "kill";

        # start a menu app
        "${cfg.config.modifier}+d" = "exec ${cfg.config.menu}";

        # make a screenshot
        "${cfg.config.modifier}+Print" = "exec ~/.local/bin/maim.sh";
        "${cfg.config.modifier}+Shift+Print" = "exec ~/.local/bin/maim.sh -s";

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
        "${cfg.config.modifier}+1" = "workspace number 1";
        "${cfg.config.modifier}+2" = "workspace number 2";
        "${cfg.config.modifier}+3" = "workspace number 3";
        "${cfg.config.modifier}+4" = "workspace number 4";
        "${cfg.config.modifier}+5" = "workspace number 5";
        "${cfg.config.modifier}+6" = "workspace number 6";
        "${cfg.config.modifier}+7" = "workspace number 7";
        "${cfg.config.modifier}+8" = "workspace number 8";
        "${cfg.config.modifier}+9" = "workspace number 9";

        # move focused container to workspace
        "${cfg.config.modifier}+Shift+1" =
          "move container to workspace number 1";
        "${cfg.config.modifier}+Shift+2" =
          "move container to workspace number 2";
        "${cfg.config.modifier}+Shift+3" =
          "move container to workspace number 3";
        "${cfg.config.modifier}+Shift+4" =
          "move container to workspace number 4";
        "${cfg.config.modifier}+Shift+5" =
          "move container to workspace number 5";
        "${cfg.config.modifier}+Shift+6" =
          "move container to workspace number 6";
        "${cfg.config.modifier}+Shift+7" =
          "move container to workspace number 7";
        "${cfg.config.modifier}+Shift+8" =
          "move container to workspace number 8";
        "${cfg.config.modifier}+Shift+9" =
          "move container to workspace number 9";

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

  config = with lib; mkIf cfg.enable {
    home.packages = [
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
      xdg-desktop-portal-wlr # xdg-desktop-portal backend for wlroots
      ydotool # xdotool for wayland
    ];
  };
}
