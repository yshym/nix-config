{ inputs, lib, pkgs, ... }:

with lib;
with lib.my; {
  imports = [ ../../platforms/nixos ../../platforms/nixos/graphical ./hardware.nix ];

  system = "x86_64-linux";

  boot = {
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_6_18;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.overlays = mapModules' ./overlays (p: import p { inherit inputs lib; });

  user.name = "yshym";

  services = {
    fwupd.enable = true;
    # logind.settings.Login = {
    #   LidSwitch = "suspend-then-hibernate";
    #   PowerKey = "hibernate";
    #   PowerKeyLongPress = "poweroff";
    #   IdleAction = "suspend-then-hibernate";
    #   IdleActionSec = "2h";
    # };
    power-profiles-daemon.enable = true;
    pulseaudio = {
      enable = false;
      systemWide = false;
      support32Bit = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
    thermald.enable = true;
    udev = {
      packages = [ pkgs.yubikey-personalization ];
      extraRules = ''
        # Rules for Oryx web flashing and live training
        KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
        KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

        # Legacy rules for live training over webusb (Not needed for firmware v21+)
        # Rule for all ZSA keyboards
        SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
        # Rule for the Moonlander
        SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"

        # Wally Flashing rules for the Moonlander and Planck EZ
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11",     MODE:="0666",     SYMLINK+="stm32_dfu"
      '';
    };
  };

  systemd.sleep.extraConfig = ''
    # HibernateDelaySec=30m
    SuspendState=mem
  '';
}
