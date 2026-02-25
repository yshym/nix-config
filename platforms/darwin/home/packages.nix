{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # system
    choose-gui
    pngpaste
    terminal-notifier
    # my.sortdir
    # my.BackgroundMusic

    # development
    chromedriver
    docker
    docker-compose
    my.Gitify

    # security
    gnupg

    # net & cloud tools
    # my.Dropbox
    wireguard-go
    wireguard-tools

    # communication
    unstable.discord
    slack

    # entertainment
    spotify-player
    my.Spotify
    # nodePackages.webtorrent-cli
  ];
}
