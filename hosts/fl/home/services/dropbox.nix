{ config, lib, pkgs, ... }:

{
  systemd.user.services.dropbox = {
    Unit = { Description = "Dropbox"; };
    Install = { WantedBy = [ "graphical-session.target" ]; };
    Service = {
      Environment =
        "QT_PLUGIN_PATH=/run/current-system/sw/${pkgs.qt5.qtbase.qtPluginPrefix}:QML2_IMPORT_PATH=/run/current-system/sw/${pkgs.qt5.qtbase.qtQmlPrefix}";
      ExecStart = "${pkgs.dropbox}/bin/dropbox";
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "always";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };
}
