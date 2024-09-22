{ config, lib, pkgs, ... }:

{
  systemd.user.services = {
    protonmail-bridge = {
      Unit = {
        Description = "Protonmail Bridge";
        After = [ "network.target" ];
        Before = lib.optional config.accounts.email.accounts.protonmail.imapnotify.enable
          "imapnotify-protonmail.service";
      };
      Service = {
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
        ExecStart =
          "${pkgs.protonmail-bridge}/bin/protonmail-bridge --no-window --noninteractive";
        Restart = "always";
        RestartSec = 30;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
