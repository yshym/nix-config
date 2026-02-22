{ lib, pkgs, ... }:

with builtins;
with lib.my; {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [ "hyprland/workspaces" "hyprland/mode" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [
        "custom/spotify"
        "backlight"
        "pulseaudio"
        "hyprland/language"
        "network"
        "battery"
        "tray"
      ];
      "hyprland/submap" = {
        tooltip = false;
        format = ''<span weight="bold">{}</span>'';
      };
      "hyprland/window" = {
        tooltip = false;
        max-length = 50;
      };
      "hyprland/language" = { format = "{short}"; };
      "custom/spotify" = {
        format = " {}";
        exec = "spotify-status";
        exec-if = "pgrep spotify";
      };
      network = {
        tooltip = false;
        format-wifi = " {essid}";
        format-ethernet = "{ifname}: {ipaddr}/{cidr}";
        format-linked = "{ifname} (No IP)";
        format-alt = "{ifname}: {ipaddr}";
        format-disconnected = "No internet";
      };
      battery = {
        format = "{icon} {capacity}";
        format-charging = " {capacity}";
        states = {
          good = 100;
          warning = 30;
          critical = 15;
        };
        format-icons = [ "" "" "" "" "" ];
      };
      backlight = {
        device = "intel_backlight";
        format = "{icon} {percent}";
        format-icons = [ "" "" "" ];
      };
      pulseaudio = {
        tooltip = false;
        format = "{icon} {volume}";
        format-bluetooth = " {volume}";
        format-bluetooth-muted = " muted";
        format-muted = "muted";
        format-source = " {volume}";
        format-source-muted = "";
        format-icons = {
          headphones = "";
          handsfree = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "" "" "" ];
        };
        on-click = "pavucontrol";
      };
      clock = {
        tooltip = false;
        # format = "{:%a %d/%m                       %H:%M    }";
        format = "{:%a %d/%m %H:%M}";
      };
      tray = {
        tooltip = false;
        icon-size = 25;
        spacing = 10;
      };
    }];
    style = readFile (toCSSFile ./style.sass);
  };

  home.packages = with pkgs; [ material-icons roboto-mono font-awesome ];
}
