{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # media
    pavucontrol
    playerctl

    my.sortdir
  ];
}
