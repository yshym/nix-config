{ config, lib, pkgs, ... }:

let
  nixosHardware = fetchTarball {
    url =
      "https://github.com/NixOS/nixos-hardware/archive/936e4649098d6a5e0762058cb7687be1b2d90550.tar.gz";
    sha256 = "06g0061xm48i5w7gz5sm5x5ps6cnipqv1m483f8i9mmhlz77hvlw";
  };
in {
  imports =
    [ "${nixosHardware}/raspberry-pi/4" ../../platforms/nixos ./home.nix ];

  boot = {
    loader.raspberryPi.firmwareConfig = ''
      dtparam=audio=on
    '';
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    bridges.br0.interfaces =
      lib.optionals config.services.hostapd.enable [ "eth0" "wlan0" ];
    networkmanager.unmanaged = lib.optionals config.services.hostapd.enable [
      "interface-name:wlan*"
      "interface-name:${config.services.hostapd.interface}"
    ];
    interfaces.wlan0 = lib.optionalAttrs config.services.hostapd.enable {
      ip4 = lib.mkOverride 0 [ ];
      ipv4.addresses = [{
        address = "192.168.0.1";
        prefixLength = 24;
      }];
    };
    firewall.allowedUDPPorts =
      lib.optionals config.services.hostapd.enable [ 5367 ];
  };

  security = {
    acme = {
      acceptTerms = false;
      email = "yshym@pm.me";
    };
  };

  services = {
    dnsmasq = lib.optionalAttrs config.services.hostapd.enable {
      enable = true;
      extraConfig = ''
        interface=wlan0
        dhcp-range=192.168.0.11,192.168.0.30,255.255.255.0,24h
      '';
    };
    haveged.enable = config.services.hostapd.enable;
    hostapd = {
      enable = false;
      interface = "wlan0";
      hwMode = "g";
      ssid = "piece-of-metal";
      wpaPassphrase = "helloworld";
    };
    spotifyd = {
      enable = true;
      settings.global = {
        backend = "pulseaudio";
        bitrate = 320;
        device_name = "rpi4";
        device_type = "speaker";
        initial_volume = "50";
        mixer = "PCM";
        password_cmd = "pass Spotify/31ar6mmjcalpg3e76aifbrzs55bi";
        use_keyring = true;
        username = "31ar6mmjcalpg3e76aifbrzs55bi";
        volume_controller = "softvol";
        volume_normalization = false;
      };
    };
    nginx = {
      enable = false;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."yevhen.space" = {
        default = true;
        enableACME = true;
        forceSSL = true;
        serverAliases = [ "www.yevhen.space" ];
        locations."/" = { return = "404"; };
        extraConfig = ''
          access_log /var/log/nginx/yevhen.space.access.log;
          error_log /var/log/nginx/yevhen.space.error.log;
        '';
      };
      virtualHosts."invidious.yevhen.space" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = { proxyPass = "http://127.0.0.1:3000"; };
        extraConfig = ''
          access_log /var/log/nginx/invidious.yevhen.space.access.log;
          error_log /var/log/nginx/invidious.yevhen.space.error.log;
        '';
      };
      virtualHosts."libretranslate.yevhen.space" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          # proxyPass = "http://127.0.0.1:8002";
          # not compatible with arm64 yet
          return = "404";
        };
        extraConfig = ''
          access_log /var/log/nginx/libretranslate.yevhen.space.access.log;
          error_log /var/log/nginx/libretranslate.yevhen.space.error.log;
        '';
      };
      virtualHosts."wwf.yevhen.space" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8001";
          proxyWebsockets = true;
        };
        extraConfig = ''
          access_log /var/log/nginx/wwf.yevhen.space.access.log;
          error_log /var/log/nginx/wwf.yevhen.space.error.log;
        '';
      };
    };
  };

  systemd = {
    services = {
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
      clear-log = {
        description = "Clear >1 month-old logs every week";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=30d";
        };
      };
    };
    timers = {
      clear-log = {
        wantedBy = [ "timers.target" ];
        partOf = [ "clear-log.service" ];
        timerConfig.OnCalendar = "Sun *-*-* 00:00:00";
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
