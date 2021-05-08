{ config, pkgs, ... }:

with pkgs; {
  imports = [ ./cachix.nix <home-manager/nix-darwin> ./home ./services ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
    };
    overlays = [ (import ./overlays/yabai.nix) ];
  };

  environment.systemPackages = [ bat vim wget ];

  fonts.fonts = [ font-awesome jetbrains-mono nerdfonts ];

  environment.darwinConfig = "$HOME/.nixpkgs/darwin/configuration.nix";

  nix = {
    package = pkgs.nix;
    trustedUsers = [ "root" "yevhenshymotiuk" ];
    gc.interval = { Weekday = 1; };
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh.enable = true;
  };

  services = {
    emacs.enable = false;
    nix-daemon.enable = true;
    postgresql.enable = true;
  };

  system = {
    defaults = {
      finder.CreateDesktop = false;
    };
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };
}
