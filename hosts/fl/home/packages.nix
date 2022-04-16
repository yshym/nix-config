{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # media
    pavucontrol
    playerctl
    my.soundux

    # communication
    slack
    zoom-us

    # security
    yubikey-manager

    my.sortdir
  ];
}
