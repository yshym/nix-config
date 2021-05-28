{ config, pkgs, ... }:

with pkgs; {
  imports = [ ./cachix.nix ./home ./host.nix ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
    };
  };

  environment = {
    systemPackages = [ bat exa vim wget ];
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
  };
}
