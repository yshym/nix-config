{ inputs, config, lib, pkgs, ... }:

with lib.my; {
  imports = [ ./services ./home ];

  nixpkgs.overlays = mapModules' ./overlays (p: import p { inherit inputs lib; });

  environment = { darwinConfig = "$HOME/.nixpkgs/configuration.nix"; };

  fonts.packages = [ pkgs.hack-font ];

  nix.gc = {
    automatic = true;
    interval = { Weekday = 1; };
  };

  # homebrew = {
  #   enable = true;
  #   # taps = [ "FelixKratz/formulae" ];
  #   brews = [
  #     "choose-gui"
  #     "openblas"
  #     # "sketchybar"
  #     # "ykman"
  #   ];
  #   casks = [ "docker" "hammerspoon" ];
  # };

  system = {
    defaults = {
      dock = {
        autohide = true;
        autohide-delay = 1000.0;
        autohide-time-modifier = 0.0;
        mineffect = "scale";
      };
      finder = {
        AppleShowAllExtensions = true;
        CreateDesktop = false;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv"; # list view
        NewWindowTarget = "Other";
        NewWindowTargetPath = "file://${config.users.users.yshym.home}/";
        ShowPathbar = true;
        QuitMenuItem = true;
      };
      screencapture.location = "~/Screenshots";

      CustomUserPreferences = {
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files for network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
      };
    };
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };
}
