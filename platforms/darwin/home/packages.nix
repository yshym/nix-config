{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # development
    chromedriver
    terminal-notifier

    # net & cloud tools
    Dropbox

    # entertainment
    Spotify

    # my stuff
    # choose
    # sortdir
  ];
}
