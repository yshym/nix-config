{ config, pkgs, ... }:

with pkgs; {
  imports = [ ./cachix.nix <home-manager/nix-darwin> ./home ./services ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
    };

    overlays = let path = ./overlays;
    in with builtins;
    map (n: import (path + ("/" + n))) (filter (n:
      match ".*\\.nix" n != null
      || pathExists (path + ("/" + n + "/default.nix")))
      (attrNames (readDir path)));
  };

  environment.systemPackages = [ bat vim ];

  fonts.fonts = [ font-awesome jetbrains-mono nerdfonts ];

  environment.darwinConfig = "$HOME/.nixpkgs/darwin/configuration.nix";

  nix = {
    package = pkgs.nix;
    trustedUsers = [ "root" "yevhenshymotiuk" ];
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

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
