{ config, pkgs, ... }:

with pkgs; {
  imports = [ ./services ./home ];

  user.home = "/home/${config.user.name}";

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
    };
  };

  modules.shell.mimi.enable = true;

  security = { sudo.wheelNeedsPassword = false; };

  programs = {
    gnupg.agent.pinentryPackage = pinentry-curses;
    zsh.enable = true;
  };

  services = {
    openssh = {
      enable = false;
      openFirewall = false;
      settings.PermitRootLogin = "no";
    };
  };

  i18n.extraLocaleSettings = { LC_TIME = "en_GB.UTF-8"; };

  system.stateVersion = "25.11";
}
