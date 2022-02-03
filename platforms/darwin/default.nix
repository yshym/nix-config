{ config, lib, pkgs, ... }:

{
  imports = [ ./home ./services ];

  nixpkgs.overlays = lib.my.modules.mapModules ./overlays import;

  environment = { darwinConfig = "$HOME/.nixpkgs/configuration.nix"; };

  nix = {
    gc = {
      user = "yshym";
      automatic = true;
      interval = { Weekday = 1; };
    };
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
