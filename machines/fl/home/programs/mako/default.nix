{ config, lib, pkgs, ... }:

{
  programs.mako = {
    enable = true;
    sort = "+time";
    anchor = "top-right";
    font = "Fira Code 15";
    backgroundColor = "#000000";
    textColor = "#ffffff";
    borderSize = 2;
    borderColor = "#b2c312";
    defaultTimeout = 5000;
  };
}
