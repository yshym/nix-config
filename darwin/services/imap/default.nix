{ config, lib, pkgs, ... }:

let
  home = config.home-manager.users.yevhenshymotiuk.home;
  homeManagerPath = home.path;
  imapnotifyConfig =
    "${home.homeDirectory}/.config/imapnotify/gmail/notify.conf";
in {
  launchd.user.agents = {
    goimapnotify.serviceConfig = {
      ProgramArguments =
        [ "${homeManagerPath}/bin/goimapnotify" "-conf" imapnotifyConfig ];
      RunAtLoad = true;
      EnvironmentVariables.PATH =
        "${homeManagerPath}/bin:${config.environment.systemPath}";
    };
    mbsync.serviceConfig = {
      ProgramArguments = [ "${pkgs.isync}/bin/mbsync" "-a" ];
      StartInterval = 300;
      RunAtLoad = true;
      EnvironmentVariables.PATH =
        "${homeManagerPath}/bin:${config.environment.systemPath}";
    };
  };
}
