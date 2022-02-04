{ config, lib, pkgs, ... }:

let
  me = "yshym";
  user = config.home-manager.users."${me}";
  home = user.home;
  homeManagerPath = home.path;
in
{
  launchd.user.agents = {
    sortdir.serviceConfig = {
      ProgramArguments = [ "${home.homeDirectory}/.local/bin/sortdir" ];
      UserName = "${me}";
      KeepAlive = true;
      ThrottleInterval = 30;
    };
  };
}
