{ config, pkgs, ... }:

{
  imports = [
    # ./brave
    ./emacs
    ./firefox
    # ./hammerspoon
    ./mbsync
    ./scripts
    ./spotify
    ./telegram
    ./vscode.nix
    ./yabai
  ];

  programs = {
    emacs = {
      enable = true;
      useHead = false;
    };
  };
}
