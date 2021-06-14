{ config, lib, pkgs, ... }:

{
  imports = [
    "${
      fetchTarball
      "https://github.com/NixOS/nixos-hardware/archive/936e4649098d6a5e0762058cb7687be1b2d90550.tar.gz"
    }/raspberry-pi/4"
    ../../platforms/nixos
    ./home.nix
  ];

  boot.loader.raspberryPi.firmwareConfig = ''
    dtparam=audio=on
  '';

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    hostName = "rpi4";
  };

  programs = {
    gnupg.agent.pinentryFlavor = "curses";
  };

  services = {
    spotifyd = {
      enable = true;
      config = ''
        [global]
        backend = "pulseaudio"
        bitrate = 320
        device_name = "rpi4"
        device_type = "speaker"
        initial_volume = "50"
        mixer = "PCM"
        password_cmd = "pass Spotify/31ar6mmjcalpg3e76aifbrzs55bi"
        use_keyring = true
        username = "31ar6mmjcalpg3e76aifbrzs55bi"
        volume_controller = "softvol"
        volume_normalization = false
      '';
    };
  };

  systemd.services = {
    bluetooth.serviceConfig.ExecStart =
      [ "" "${pkgs.bluez}/libexec/bluetooth/bluetoothd --noplugin=sap" ];
    btattach = {
      before = [ "bluetooth.service" ];
      after = [ "dev-ttyAMA0.device" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart =
          "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
      };
    };
  };

  sound.enable = true;

  hardware = {
    # Enable GPU acceleration
    raspberry-pi."4".fkms-3d.enable = true;
    enableRedistributableFirmware = true;
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
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
