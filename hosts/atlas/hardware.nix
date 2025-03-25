{ inputs, lib, pkgs, modulesPath, ... }:

{
  imports = [
    inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/210e8ea6-4b13-4f83-93e1-dcab93f4c8e7";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/36AF-1CF4";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };


  swapDevices = [ ];

  hardware = {
    asahi = {
      enable = true;
      setupAsahiSound = true;
      peripheralFirmwareDirectory = ./firmware;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "replace";
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };
}
