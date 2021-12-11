{ config, lib, pkgs, ... }:

{
  imports = [ ../../platforms/nixos ./hardware.nix ./home ];

  boot = {
    cleanTmpDir = true;
    kernelPackages = pkgs.linuxPackages_5_15;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  services = { fprintd.enable = true; };

  networking = { hostName = "fl"; };

  programs = {
    gnupg.agent.pinentryFlavor = "curses";
    light.enable = true;
  };

  sound.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    pulseaudio = {
      enable = true;
      systemWide = false;
      support32Bit = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
  };
}
