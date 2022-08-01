{ inputs, lib, pkgs, ... }:

with lib;
with lib.my; {
  imports = [ ../../platforms/nixos ./hardware.nix ./home ];

  boot = {
    cleanTmpDir = true;
    kernelPackages = pkgs.linuxPackages_5_18;
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
    geoclue2.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      media-session.config.bluez-monitor.rules = [
        {
          # Matches all cards
          matches = [{ "device.name" = "~bluez_card.*"; }];
          actions = {
            "update-props" = {
              "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
              # mSBC is not expected to work on all headset + adapter combinations.
              "bluez5.msbc-support" = true;
              # SBC-XQ is not expected to work on all headset + adapter combinations.
              "bluez5.sbc-xq-support" = true;
            };
          };
        }
        {
          matches = [
            # Matches all sources
            {
              "node.name" = "~bluez_input.*";
            }
            # Matches all outputs
            { "node.name" = "~bluez_output.*"; }
          ];
          actions = { "node.pause-on-idle" = false; };
        }
      ];
    };
    udev.packages = [ pkgs.yubikey-personalization ];
  };

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
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
    wlr.enable = true;
  };
}
