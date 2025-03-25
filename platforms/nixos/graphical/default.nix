{ inputs, config, lib, pkgs, ... }:
{
  imports = [ ./home ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrains Mono" ];
    serif = [ "DejaVu Serif" ];
    sansSerif = [ "DejaVu Sans" ];
  };

  programs = {
    dconf.enable = true;
    hyprland = {
      enable = false;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    light.enable = true;
  };

  services = {
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --cmd ${pkgs.sway}/bin/sway";
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
      wireplumber.extraConfig = {
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
      };
    };
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

  xdg.portal = {
    config.common.default = "*";
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    # gtkUsePortal = true;
    wlr.enable = true;
  };
}
