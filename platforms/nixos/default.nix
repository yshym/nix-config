{ config, pkgs, lib, ... }:

with pkgs; {
  imports = [ <home-manager/nixos> ./home ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "curses";
    };
  };

  services = {
    openssh = {
      enable = true;
    };
  };
}
