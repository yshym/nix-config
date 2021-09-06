{ config, pkgs, lib, ... }:

with pkgs; {
  imports = [ ./home ./services ];

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
