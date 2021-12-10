{ config, lib, pkgs, ... }:

{
  programs.mako = {
    enable = true;
    sort = "+time";
    anchor = "top-right";
    width = 250;
    font = "Fira Code 9";
    backgroundColor = "#282a36";
    textColor = "#f8f8f2";
    borderSize = 2;
    borderColor = "#44475a";
    defaultTimeout = 5000;
  };
}
