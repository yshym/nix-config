{ config, lib, pkgs, ... }:

{
  systemd.user.services = {
    goimapnotify = {
      Unit.Description = "IMAP notifier using IDLE, golang version";
      Service = {
        ExecStart =
          "${pkgs.goimapnotify}/bin/goimapnotify -conf %h/.config/imapnotify/gmail/notify.conf";
        Restart = "always";
        RestartSec = 30;
      };
      Install.WantedBy = [ "default.target" ];
    };
    proton-bridge = {
      Unit.Description = "proton-bridge";
      Service = {
        ExecStart =
          "${pkgs.protonmail-bridge}/bin/protonmail-bridge --no-window";
        Restart = "always";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
