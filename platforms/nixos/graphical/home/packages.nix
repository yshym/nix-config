{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # dev
    colima

    # media
    pavucontrol
    playerctl
    # my.soundux
    # nodePackages.webtorrent-cli

    # communication
    (if pkgs.stdenv.isAarch64 then legcord else discord)
    slack

    # security
    unstable.paretosecurity
    pinentry-curses
    yubikey-manager

    # entertaiment
    chatterino2
    spotify-player

    # other
    # my.sortdir
  ];
}
