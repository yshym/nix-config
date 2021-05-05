{ config, lib, pkgs, ... }:

let
  me = "yevhenshymotiuk";
  user = config.home-manager.users."${me}";
  home = user.home;
  homeFiles = user.home-files;
  homeManagerPath = home.path;
in {
  launchd.user.agents = {
    google-calendar-to-org.serviceConfig = {
      ProgramArguments = [ "${homeFiles}/.local/bin/ical2org_wrapper" ];
      UserName = "${me}";
      KeepAlive = true;
      StartCalendarInterval = [{ Minute = 5; }];
      ThrottleInterval = 30;
      EnvironmentVariables.PATH =
        "${homeManagerPath}/bin:${homeFiles}/.local/bin:${config.environment.systemPath}";
    };
  };
}
