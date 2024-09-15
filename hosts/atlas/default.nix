{ inputs, lib, pkgs, ... }:

{
  imports = [
    inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
    ./hardware.nix
    ../../platforms/nixos
    ./home
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    extraModprobeConfig = ''
      options hid_apple iso_layout=0
    '';
    initrd.kernelModules = [
      "nvme"
      "usbhid"
      "usb_storage"
      "ext4"
      "dm-snapshot"
    ];
    kernelParams = [ "apple_dcp.show_notch=1" ];
  };

  nixpkgs.overlays = [ inputs.nixos-apple-silicon.overlays.apple-silicon-overlay ];

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  services.logind = {
    powerKey = "ignore";
    suspendKey = "ignore";
  };
}
