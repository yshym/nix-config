{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # development
    chromedriver
    terminal-notifier

    # security
    gnupg

    # net & cloud tools
    my.Dropbox
    wireguard-go
    wireguard-tools

    # entertainment
    # my.Spotify

    # my stuff
    # my.choose
    # sortdir
  ];
}
