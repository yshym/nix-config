{ config, pkgs, ... }:

{
  imports = [
    # ./brave
    # ./hammerspoon
    ./mbsync
    ./scripts
    ./spotify
    ./telegram
    ./vscode.nix
    ./yabai
  ];

  programs = {
    firefox.package = pkgs.Firefox;
  };
}
