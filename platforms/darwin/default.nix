{ config, lib, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ./home ./services ];

  nixpkgs.overlays = [ (import ./overlays/yabai.nix) ];

  environment = {
    darwinConfig = "$HOME/.nixpkgs/configuration.nix";
  };

  nix = {
    gc = {
      automatic = true;
      interval = { Weekday = 1; };
    };
  };

  services = {
    nix-daemon.enable = true;
  };

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
    };
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };
}
