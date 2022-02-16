{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.swaylock;
  wrapper = pkgs.writeShellScriptBin
    "swaylock-wrapper"
    ''
      exec ${pkgs.swaylock-effects}/bin/swaylock \
        --screenshots \
        --clock \
        --indicator \
        --indicator-radius 100 \
        --indicator-thickness 7 \
        --effect-blur 7x5 \
        --effect-vignette 0.5:0.5 \
        --ring-color bd93f9 \
        --key-hl-color ff79c6 \
        --line-color 00000000 \
        --inside-color 282a36 \
        --separator-color 00000000 \
        --fade-in 0.2
    '';
in
{
  options.programs.swaylock = {
    enable = mkEnableOption "Swaylock";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (symlinkJoin
        {
          name = "swaylock-wrapper";
          paths = [
            wrapper
            swaylock-effects
          ];
        })
    ];
  };
}
