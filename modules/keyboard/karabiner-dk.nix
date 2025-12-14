{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.keyboard.karabiner-dk;
  nixAppsDir = "/Applications/Nix Apps";
in
{
  options.modules.keyboard.karabiner-dk = {
    enable = mkEnableOption "Karabiner-DK";
    package = mkPackageOption pkgs "karabiner-dk" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    launchd.daemons.Karabiner-DriverKit-VirtualHIDDevice-Daemon = mkIf pkgs.stdenv.isDarwin {
      command = "${cfg.package}/Library/Application\\ Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";
      serviceConfig = {
        ProcessType = "Interactive";
        Label = "org.pqrs.Karabiner-DriverKit-VirtualHIDDevice-Daemon";
        RunAtLoad = true;
        KeepAlive = true;
      };
    };
    launchd.daemons.start-karabiner-dk = mkIf pkgs.stdenv.isDarwin {
      script = ''
        spctl -a -vvv -t install "${cfg.package}/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager"
        "${nixAppsDir}/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager" activate
      '';
      serviceConfig.RunAtLoad = true;
    };
    system.activationScripts.postActivation.text = mkIf pkgs.stdenv.isDarwin (mkAfter ''
      launchctl kickstart -k system/org.pqrs.Karabiner-DriverKit-VirtualHIDDevice-Daemon
    '');
  };
}
