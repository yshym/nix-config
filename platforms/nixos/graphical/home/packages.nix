{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # media
    pavucontrol
    playerctl
    # my.soundux
    # nodePackages.webtorrent-cli

    # communication
    armcord
    # discord
    # slack

    # security
    pinentry
    yubikey-manager

    # entertaiment
    chatterino2

    # other
    # my.sortdir
  ];
}
