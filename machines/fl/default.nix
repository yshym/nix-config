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

  nixpkgs.overlays = [ (import ./overlays/wluma) ];

  services = { fprintd.enable = true; };

  networking = { hostName = "fl"; };

  programs = {
    gnupg.agent.pinentryFlavor = "curses";
    light.enable = true;
  };

  sound.enable = true;
}
