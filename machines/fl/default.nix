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

  nixpkgs.overlays =
    [ (import ./overlays/wluma) (import ./overlays/nix-direnv.nix) ];

  networking = { hostName = "fl"; };

  programs = {
    gnupg.agent.pinentryFlavor = "curses";
    light.enable = true;
  };

  services = {
    fprintd.enable = true;
    geoclue2.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    transmission.enable = true;
  };

  sound.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
    wlr.enable = true;
  };
}
