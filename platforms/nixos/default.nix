{ config, pkgs, lib, ... }:

with pkgs; {
  imports = [ <home-manager/nixos> ./home ./services ];

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

  services = {
    openssh = {
      enable = true;
    };
  };
}
