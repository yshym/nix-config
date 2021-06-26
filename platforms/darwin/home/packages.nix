{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ../overlays/dropbox)
    (import ../overlays/sortdir)
    (import ../overlays/spotify)
  ];

  home.packages = with pkgs; [
    # development
    chromedriver
    terminal-notifier

    # net & cloud tools
    Dropbox

    # entertainment
    Spotify

    # my stuff
    # sortdir
  ];
}
