{ config, lib, pkgs, ... }:

{
  services.kanshi = {
    enable = true;
    profiles = {
      undocked = { outputs = [{ criteria = "eDP-1"; }]; };
      docked = {
        outputs = [
          {
            criteria = "DP-4";
            position = "0,0";
            scale = 1.5;
          }
          {
            criteria = "eDP-1";
            position = "1280,0";
          }
        ];
        exec =
          [ "${pkgs.sway}/bin/swaymsg workspace 1, move workspace to DP-4" ];
      };
    };
  };
}
