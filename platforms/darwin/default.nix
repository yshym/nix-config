{ inputs, config, lib, pkgs, ... }:

with lib.my; {
  imports = [ ./services ./home ];

  nixpkgs.overlays = mapModules' ./overlays (p: import p { inherit inputs lib; });

  environment = { darwinConfig = "$HOME/.nixpkgs/configuration.nix"; };

  fonts = {
    fonts = [ pkgs.hack-font ];
    fontDir.enable = true;
  };

  nix = {
    gc = {
      user = "yshym";
      automatic = true;
      interval = { Weekday = 1; };
    };
  };

  homebrew = {
    enable = true;
    taps = [ "FelixKratz/formulae" ];
    brews = [ "choose-gui" "openblas" "sketchybar" "ykman" ];
    casks = [ "docker" "hammerspoon" ];
  };

  services = { nix-daemon.enable = true; };

  system = {
    defaults = {
      dock = {
        autohide = true;
        autohide-delay = "1000";
        autohide-time-modifier = "0";
        mineffect = "scale";
      };
      finder = {
        CreateDesktop = false;
        QuitMenuItem = true;
      };
      screencapture.location = "~/Screenshots";
    };
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };
}
