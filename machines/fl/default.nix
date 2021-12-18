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

  networking = { hostName = "fl"; };

  programs = {
    gnupg.agent.pinentryFlavor = "curses";
    light.enable = true;
  };

  services = {
    geoclue2.enable = true;
    fprintd.enable = true;
    # pipewire.enable = true;
  };

  sound.enable = true;

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  #   gtkUsePortal = true;
  #   wlr.enable = true;
  # };
}
