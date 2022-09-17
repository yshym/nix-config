{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # development
    chromedriver
    docker
    docker-compose
    terminal-notifier

    # security
    gnupg

    # net & cloud tools
    my.Dropbox
    wireguard-go
    wireguard-tools

    # communication
    discord-ptb
    slack

    # entertainment
    # my.Spotify
    nodePackages.webtorrent-cli

    # my stuff
    # my.choose
    # sortdir
  ];
}
