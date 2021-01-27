{ config, pkgs, ... }:

with pkgs;
{
  imports = [
    <home-manager/nix-darwin>
    ./home
    ./services
  ];

  nixpkgs.overlays = [
    # (self: super: {
    #   emacs = super.emacs.override {
    #     withNS = false;
    #     withX = true;
    #     withGTK3 = true;
    #     withXwidgets = true;
    #   };
    # })
    (self: super: {
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
    })
  ];

  environment.systemPackages = [
    bat
    # emacs
    vim
  ];

  fonts.fonts = [
    font-awesome
    jetbrains-mono
    nerdfonts
  ];

  # environment.darwinConfig = "$HOME/.nixpkgs/darwin/configuration.nix";

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
