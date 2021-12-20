{ config, pkgs, ... }:

with pkgs; {
  imports = [ ./cachix.nix ./home ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
      pulseaudio = true;
    };
    overlays = [
      (import (builtins.fetchTarball {
        url =
          "https://github.com/nix-community/emacs-overlay/archive/9578b9dbce95d9077c2c9b4e06391985670b059c.tar.gz";
        sha256 = "0xw7c2sca0qw74faddq9q7289f98kc2yc51jnlk6nbgaddi7xscx";
      }))
    ];
  };

  environment = {
    systemPackages = [ bat coreutils exa gcc ripgrep vim wget ];
  };

  fonts.fonts = [ fira-code font-awesome jetbrains-mono noto-fonts-cjk ];

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
  };

  services = { emacs.enable = false; };

  time.timeZone = "Europe/Kiev";
}
