{ config, lib, pkgs, ... }:

{
  imports = [ ../../platforms/nixos ./home ];

  boot = {
    cleanTmpDir = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services = {
    fprintd.enable = true;
  };

  networking = { hostName = "fl"; };

  programs = { gnupg.agent.pinentryFlavor = "curses"; };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    pulseaudio = {
      enable = true;
      systemWide = true;
      support32Bit = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        unload-module module-native-protocol-unix
        load-module module-native-protocol-unix auth-anonymous=1
        load-module module-switch-on-connect
      '';
    };
  };
}