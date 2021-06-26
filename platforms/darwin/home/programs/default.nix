{ config, pkgs, ... }:

{
  imports = [
    ./emacs
    ./firefox
    ./hammerspoon
    ./mbsync
    ./scripts
    ./spotify
    ./telegram
    ./yabai
  ];

  programs = {
    emacs = {
      enable = true;
      useHead = false;
    };
  };
}
