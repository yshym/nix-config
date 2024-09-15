{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # media
    pavucontrol
    playerctl
    # my.soundux
    nodePackages.webtorrent-cli

    # communication
    discord
    slack
    zoom-us

    # security
    pinentry
    yubikey-manager


    # entertaiment
    chatterino2

    # other
    # my.sortdir
  ];
}
