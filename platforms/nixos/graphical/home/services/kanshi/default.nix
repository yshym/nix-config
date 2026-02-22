{ config, lib, pkgs, ... }:

let
  # TODO Fix ultrawide gaps
  cfg = config.services.kanshi;
  defaultGapsOut = config.wayland.windowManager.hyprland.settings.general.gaps_out;
  ultrawideScale = (builtins.head cfg.profiles.docked.outputs).scale;
  ultrawideGapsOut = 500 / ultrawideScale;
in
{
  services.kanshi = {
    enable = true;
    profiles = {
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
          }
        ];
        exec = [
          # Set gaps out to default
          "${pkgs.hyprland}/bin/hyprctl keyword general:gaps_out ${toString defaultGapsOut}"
          # Disable gaps for a single window on a workspace
          "${pkgs.hyprland}/bin/hyprctl keyword workspace w[tv1], gapsin:0, gapsout:0"
        ];
      };
      docked = {
        outputs = [
          {
            criteria = "DP-4";
            position = "0,0";
            scale = 1.333;
          }
          {
            criteria = "eDP-1";
            status = "disable";
            position = "720,960";
          }
        ];
        exec = [
          # Move current workspace to the external display
          "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor current DP-4"
          # Set gaps out to ultrawide
          "${pkgs.hyprland}/bin/hyprctl keyword general:gaps_out ${toString defaultGapsOut},${toString ultrawideGapsOut},${toString defaultGapsOut},${toString ultrawideGapsOut}"
          # Disable gaps for a single window on a workspace taking into account ultrawide l|r gaps out
          "${pkgs.hyprland}/bin/hyprctl keyword workspace w[tv1], gapsin:0, gapsout:0 ${toString ultrawideGapsOut} 0 ${toString ultrawideGapsOut}"
        ];
      };
    };
  };
}
