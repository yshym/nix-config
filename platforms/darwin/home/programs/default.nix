{ config, pkgs, ... }:

{
  imports = [
    # ./brave
    # ./hammerspoon
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
