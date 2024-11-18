{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # development
    chromedriver
    docker
    docker-compose
    my.Gitify
    terminal-notifier

    # security
    gnupg

    # net & cloud tools
    # my.Dropbox
    wireguard-go
    wireguard-tools

    # communication
    discord
    slack

    # entertainment
    my.Spotify
    # nodePackages.webtorrent-cli

    # my stuff
    # my.choose
    # my.sortdir
    pngpaste
  ];
}
