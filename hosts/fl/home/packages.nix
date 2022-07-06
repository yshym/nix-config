{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # media
    pavucontrol
    playerctl
    my.soundux

    # communication
    discord
    slack
    zoom-us

    # security
    yubikey-manager

    my.sortdir
  ];
}
