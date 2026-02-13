{ pkgs, ... }:

let
  darkBlue = "6272a4";
  darkGrey = "333333";
in {
  services.jankyborders = {
    enable = true;
    package = pkgs.unstable.jankyborders;
    active_color = "0xff${darkBlue}";
    inactive_color = "0xff${darkGrey}";
    width = 5.0;
    hidpi = false;
    order = "above";
    blacklist = [ "choose" ];
  };
}
