{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # media
    pavucontrol
    playerctl

    # communication
    zoom-us

    my.sortdir
  ];
}
