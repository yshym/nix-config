{ config, ... }:

let
  homeManagerPath = config.home.home.path;
in
{
  launchd.user.agents = {
    calendar-to-org.serviceConfig = {
      ProgramArguments = [ "${config.user.home}/.local/bin/ical2org-wrapper" ];
      UserName = "${config.user.name}";
      KeepAlive = true;
      StartCalendarInterval = [{ Minute = 5; }];
      ThrottleInterval = 30;
      EnvironmentVariables.PATH =
        "${homeManagerPath}/bin:${config.user.home}/.local/bin:${config.environment.systemPath}";
    };
  };
}
