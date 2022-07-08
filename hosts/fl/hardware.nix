{ config, inputs, lib, pkgs, modulesPath, ... }:

{
  imports = [ inputs.nixos-hardware.nixosModules.framework (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
  };
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    i2c.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
    };
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
    sensor.iio.enable = true;
    # high-resolution display
    video.hidpi.enable = true;
  };
}
