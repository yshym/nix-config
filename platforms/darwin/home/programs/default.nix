{ config, pkgs, ... }:

{
  imports = [
    # ./brave
    ./emacs
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
    firefox.package = pkgs.Firefox;
  };
}
