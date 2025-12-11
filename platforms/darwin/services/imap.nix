{ config, pkgs, ... }:

let
  homeManagerPath = config.home.path;
  imapnotifyConfig =
    "${config.home.homeDirectory}/.config/imapnotify/gmail/notify.conf";
in
{
  launchd.user.agents = {
    # goimapnotify.serviceConfig = {
    #   ProgramArguments =
    #     [ "${pkgs.goimapnotify}/bin/goimapnotify" "-conf" imapnotifyConfig ];
    #   UserName = "${config.user.name}";
    #   RunAtLoad = true;
    #   ThrottleInterval = 30;
    #   EnvironmentVariables.PATH =
    #     "${homeManagerPath}/bin:${config.environment.systemPath}";
    # };
    mbsync.serviceConfig = {
      ProgramArguments = [ "${pkgs.isync}/bin/mbsync" "-a" ];
      UserName = "${config.user.name}";
      StartInterval = 300;
      RunAtLoad = true;
      ThrottleInterval = 30;
      EnvironmentVariables.PATH =
        "${homeManagerPath}/bin:${config.environment.systemPath}";
    };
    proton-bridge.serviceConfig = {
      ProgramArguments = [ "${pkgs.protonmail-bridge}/bin/protonmail-bridge" "--no-window" ];
      UserName = "${config.user.name}";
      StartInterval = 300;
      RunAtLoad = true;
      ThrottleInterval = 30;
      EnvironmentVariables.PATH =
        "${homeManagerPath}/bin:${config.environment.systemPath}";
    };
  };
}
