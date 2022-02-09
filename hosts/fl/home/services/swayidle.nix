{ lib, pkgs, ... }:

with lib;
let
  # TODO Create swaylock module
  lock-command = ''
    ${pkgs.swaylock-effects}/bin/swaylock \
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
      --grace 2 \
      --fade-in 0.2'';
in
{
  services.swayidle = {
    enable = true;
    timeouts = [{ timeout = 600; command = lock-command; }];
    events = [{ event = "before-sleep"; command = lock-command; }];
  };
}
