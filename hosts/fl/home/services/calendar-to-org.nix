{ config, lib, pkgs, ... }:

{
  systemd.user = {
    services.calendar-to-org = {
      Unit.Description = "Synchronizing calendar and org-mode";
      Service.ExecStart =
        "${config.home.homeDirectory}/.local/bin/ical2org_wrapper";
    };
    timers.calendar-to-org = {
      Unit.Description = "Synchronizing calendar and org-mode timer";
      Timer = {
        Unit = "calendar-to-org.service";
        OnCalendar = "*:0/5";
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
