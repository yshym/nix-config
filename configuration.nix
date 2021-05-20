{ config, pkgs, ... }:

with pkgs; {
  imports = [ ./cachix.nix ./darwin ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
    };
  };

  environment = {
    systemPackages = [ bat vim wget ];
  };

  fonts.fonts = [ font-awesome jetbrains-mono nerdfonts ];

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
    postgresql.enable = true;
  };
}
