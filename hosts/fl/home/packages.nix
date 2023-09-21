{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # media
    pavucontrol
    playerctl
    # my.soundux
    nodePackages.webtorrent-cli

    # communication
    discord-ptb
    slack
    zoom-us

    # security
    yubikey-manager

    # my.sortdir
  ];
}
