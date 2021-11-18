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
    emacs.enable = true;
    firefox.package = pkgs.Firefox;
  };
}
