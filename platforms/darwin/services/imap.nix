{ config, lib, pkgs, ... }:

let
  me = "yshym";
  home = config.home-manager.users."${me}".home;
  homeManagerPath = home.path;
  imapnotifyConfig =
    "${home.homeDirectory}/.config/imapnotify/gmail/notify.conf";
in
{
  launchd.user.agents = {
    # goimapnotify.serviceConfig = {
    #   ProgramArguments =
    #     [ "${pkgs.goimapnotify}/bin/goimapnotify" "-conf" imapnotifyConfig ];
    #   UserName = "${me}";
    #   RunAtLoad = true;
    #   ThrottleInterval = 30;
    #   EnvironmentVariables.PATH =
    #     "${homeManagerPath}/bin:${config.environment.systemPath}";
    # };
    mbsync.serviceConfig = {
      ProgramArguments = [ "${pkgs.isync}/bin/mbsync" "-a" ];
      UserName = "${me}";
      StartInterval = 300;
      RunAtLoad = true;
      ThrottleInterval = 30;
      EnvironmentVariables.PATH =
        "${homeManagerPath}/bin:${config.environment.systemPath}";
    };
    proton-bridge.serviceConfig = {
      ProgramArguments = [ "${pkgs.protonmail-bridge}/bin/protonmail-bridge" "--no-window" ];
      UserName = "${me}";
      StartInterval = 300;
      RunAtLoad = true;
      ThrottleInterval = 30;
      EnvironmentVariables.PATH =
        "${homeManagerPath}/bin:${config.environment.systemPath}";
    };
  };
}
