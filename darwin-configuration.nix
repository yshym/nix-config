{ config, pkgs, ... }:

with pkgs;
let me = "yevhenshymotiuk";
in {
  imports = [
    <home-manager/nix-darwin>
    ./home
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ 
      bat
      vim
    ];

  fonts.fonts = with pkgs; [
    dejavu_fonts
    fira-code
    fira-code-symbols
    font-awesome_5
    iosevka
    material-icons
    powerline-fonts
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  programs = {
    zsh.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    emacs.enable = true;
    postgresql.enable = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
