{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.modules.keyboard.karabiner-dk;
  isDarwin = my.isDarwin system;
  nixAppsDir = "/Applications/Nix Apps";
in
{
  options.modules.keyboard.karabiner-dk = {
    enable = mkEnableOption "Karabiner-DK";
    package = mkPackageOption pkgs "karabiner-dk" { };
  };

  config = mkIf cfg.enable ({
    environment.systemPackages = [ cfg.package ];
  } // (optionalAttrs isDarwin {
    launchd.daemons = {
      Karabiner-DriverKit-VirtualHIDDevice-Daemon = {
        command = "${cfg.package}/Library/Application\\ Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";
        serviceConfig = {
          ProcessType = "Interactive";
          Label = "org.pqrs.Karabiner-DriverKit-VirtualHIDDevice-Daemon";
          RunAtLoad = true;
          KeepAlive = true;
        };
      };
      start-karabiner-dk = {
        script = ''
          spctl -a -vvv -t install "${cfg.package}/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager"
          "${nixAppsDir}/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager" activate
        '';
        serviceConfig.RunAtLoad = true;
      };
    };
    system.activationScripts.postActivation.text = ''
      launchctl kickstart -k system/org.pqrs.Karabiner-DriverKit-VirtualHIDDevice-Daemon
    '';
  }));
}
