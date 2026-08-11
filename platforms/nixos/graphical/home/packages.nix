{ pkgs, mv, ... }:

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
    mv.versions.paretosecurity."0.3.21"
    pinentry-curses
    yubikey-manager

    # entertaiment
    chatterino2
    spotify-player

    # other
    # my.sortdir
  ];
}
