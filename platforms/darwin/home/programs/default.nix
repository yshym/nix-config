{ config, pkgs, ... }:

{
  imports = [
    ./brave
    # ./hammerspoon
    ./scripts
    ./sketchybar
    ./spotify
    ./telegram
    ./vscode.nix
    ./yabai
  ];

  programs = {
    firefox.package = pkgs.my.FirefoxDev;
    zsh.sessionVariables.BROWSER = "brave";
  };
}
