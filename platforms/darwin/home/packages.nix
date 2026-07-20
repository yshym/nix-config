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
    docker_29
    docker-compose

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
    iina
    my.Spotify
    # nodePackages.webtorrent-cli
    my.Menu
  ];
}
