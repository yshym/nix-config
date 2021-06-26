{ config, lib, pkgs, ... }:

let
  me = "yevhenshymotiuk";
  user = config.home-manager.users."${me}";
  home = user.home;
  homeManagerPath = home.path;
in {
  launchd.user.agents = {
    sortdir.serviceConfig = {
      ProgramArguments = [
        "${home.homeDirectory}/.local/bin/sortdir"
        "${home.homeDirectory}/Downloads"
      ];
      UserName = "${me}";
      KeepAlive = true;
      ThrottleInterval = 30;
    };
  };
}
