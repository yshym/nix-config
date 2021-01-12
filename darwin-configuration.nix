{ config, pkgs, ... }:

with pkgs;
let me = "yevhenshymotiuk";
in {
  imports = [
    <home-manager/nix-darwin>
    ./home
    ./services
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ 
      bat
      vim
    ];

  nixpkgs.config.packageOverrides = super: {
    yabai = super.yabai.overrideAttrs (o: rec {
      version = "3.3.6";
      src = builtins.fetchTarball {
        url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
        sha256 = "00iblhdx89wyvasl3hm95w91z4mrwb7pbfdvg9cmpcnqphbfs5ld";
      };

      installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/share/man/man1/
        cp ./archive/bin/yabai $out/bin/yabai
        cp ./archive/doc/yabai.1 $out/share/man/man1/yabai.1
      '';
    });
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # nix.useSandbox = true;

  programs = {
    zsh.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    emacs.enable = false;
    postgresql.enable = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
