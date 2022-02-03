{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # development
    chromedriver
    terminal-notifier

    # net & cloud tools
    my.Dropbox

    # entertainment
    my.Spotify

    # my stuff
    # choose
    # sortdir
  ];
}
