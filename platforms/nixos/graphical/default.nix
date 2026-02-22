{ inputs, config, lib, pkgs, ... }:

{
  imports = [ ./home ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrains Mono" ];
    serif = [ "DejaVu Serif" ];
    sansSerif = [ "DejaVu Sans" ];
  };

  programs = {
    light.enable = true;
  };

  services = {
    dbus.enable = true;
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet -r --cmd ${pkgs.hyprland}/bin/start-hyprland";
        user = "greeter";
      };
    };
    geoclue2.enable = true;
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      wireplumber = {
        enable = true;
        extraConfig = {
          "log-level-debug" = {
            "context.properties" = {
              # Output Debug log messages as opposed to only the default level (Notice)
              "log.level" = "D";
            };
          };
          "wh-1000xm5-ldac-hq" = {
            "monitor.bluez.rules" = [
              {
                matches = [
                  {
                    # Match any bluetooth device with ids equal to that of a WH-1000XM3
                    "device.name" = "~bluez_card.*";
                    "device.product.id" = "0x0024";
                    "device.vendor.id" = "usb:054C";
                  }
                ];
                actions = {
                  update-props = {
                    # Set quality to high quality instead of the default of auto
                    "bluez5.a2dp.ldac.quality" = "hq";
                  };
                };
              }
            ];
          };
          # Enable hdmi stereo output for the internal sound card
          "hdmi-audio" = {
            "monitor.alsa.rules" = [
              {
                matches = [
                  { "device.name" = "~alsa_card.pci-0000_00_1f.3"; }
                ];
                actions = {
                  update-props = {
                    "device.profile" = "output:hdmi-stereo";
                  };
                };
              }
            ];
          };
        };
      };
    };
  };

  modules.desktop.apps = {
    swaylock-custom.enable = true;
    wofi-custom.enable = true;
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
    rtkit.enable = true;
  };

  xdg.portal = {
    config.common.default = "*";
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    # gtkUsePortal = true;
    wlr.enable = true;
  };
}
