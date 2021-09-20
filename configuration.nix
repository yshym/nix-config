{ config, pkgs, ... }:

with pkgs; {
  imports = [ ./cachix.nix ./home ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
    };
  };

  environment = {
    systemPackages = [ bat coreutils exa gcc ripgrep vim wget ];
  };

  fonts.fonts = [ font-awesome jetbrains-mono nerdfonts ];

  nix = {
    package = pkgs.nixFlakes;
    trustedUsers = [ "root" "yevhenshymotiuk" ];
    useSandbox = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
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
