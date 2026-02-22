{ config, inputs, lib, pkgs, modulesPath, ... }:

{
  imports = [ inputs.nixos-hardware.nixosModules.framework-11th-gen-intel (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    resumeDevice = "/dev/disk/by-uuid/90743b97-0b54-45e5-8550-d0cbac218fe1";
    kernelParams = [ "resume_offset=39172096" "mem_sleep_default=deep" "usbcore.autosuspend=-1" ];
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

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
    # {
    #   device = "/var/lib/swapfile";
    #   size = 16 * 1024; # 16GB
    # }
  ];

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
    graphics.enable = true;
    sensor.iio.enable = true;
  };
}
