{ inputs, lib, pkgs, ... }:

with lib;
with lib.my; {
  imports = [ ../../platforms/nixos ./hardware.nix ./home ];

  boot = {
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_6_6;
    resumeDevice = "/dev/disk/by-label/swap";
    kernelParams = [ "mem_sleep_default=deep" "usbcore.autosuspend=-1" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.overlays = mapModules' ./overlays (p: import p { inherit inputs lib; });

  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrains Mono" ];
    serif = [ "DejaVu Serif" ];
    sansSerif = [ "DejaVu Sans" ];
  };

  programs = {
    light.enable = true;
  };

  services = {
    fwupd.enable = true;
    geoclue2.enable = true;
    logind = {
      lidSwitch = "suspend-then-hibernate";
      extraConfig = ''
        HandlePowerKey=suspend-then-hibernate
        IdleAction=suspend-then-hibernate
        IdleActionSec=30m
      '';
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      # media-session.config.bluez-monitor.rules = [
      #   {
      #     # Matches all cards
      #     matches = [{ "device.name" = "~bluez_card.*"; }];
      #     actions = {
      #       "update-props" = {
      #         "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
      #         # mSBC is not expected to work on all headset + adapter combinations.
      #         "bluez5.msbc-support" = true;
      #         # SBC-XQ is not expected to work on all headset + adapter combinations.
      #         "bluez5.sbc-xq-support" = true;
      #       };
      #     };
      #   }
      #   {
      #     matches = [
      #       # Matches all sources
      #       {
      #         "node.name" = "~bluez_input.*";
      #       }
      #       # Matches all outputs
      #       { "node.name" = "~bluez_output.*"; }
      #     ];
      #     actions = { "node.pause-on-idle" = false; };
      #   }
      # ];
      wireplumber.enable = true;
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
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
  };

  systemd.sleep.extraConfig = "HibernateDelaySec=30s";

  security = {
    pam = {
      yubico = {
        enable = true;
        mode = "challenge-response";
      };
      services = {
        swaylock = { };
        swaylock-wrapper = { };
      };
    };
  };

  sound.enable = false;

  xdg.portal = {
    config.common.default = "*";
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    # gtkUsePortal = true;
    wlr.enable = true;
  };
}
