{ config, pkgs, lib, ... }:

with pkgs; {
  imports = [ ./services ./home ];

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

  security = { sudo.wheelNeedsPassword = false; };

  programs = { gnupg.agent.pinentryFlavor = "curses"; };

  services = { openssh = { enable = true; }; };

  i18n.extraLocaleSettings = { LC_TIME = "en_GB.UTF-8"; };
}
