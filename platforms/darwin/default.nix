{ config, lib, pkgs, ... }:

{
  imports = [ ./services ./home ];

  nixpkgs.overlays = lib.my.modules.mapModules' ./overlays import;

  environment = { darwinConfig = "$HOME/.nixpkgs/configuration.nix"; };

  fonts.fontDir.enable = true;

  nix = {
    gc = {
      user = "yshym";
      automatic = true;
      interval = { Weekday = 1; };
    };
  };

  homebrew = {
    enable = true;
    brews = [ "choose-gui" "ykman" ];
    casks = [ "slack" ];
    extraConfig = ''
      brew "libxml2", link: true
      brew "libxslt", link: true
    '';
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
