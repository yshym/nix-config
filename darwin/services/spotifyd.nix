{ config, lib, pkgs, ... }:

let
  me = "yevhenshymotiuk";
  home = config.home-manager.users."${me}".home;
  spotifydConfig = "${home.homeDirectory}/.config/spotifyd/spotifyd.conf";
in {
  launchd.user.agents = {
    spotifyd.serviceConfig = {
      ProgramArguments =
        [ "${pkgs.spotifyd}/bin/spotifyd" "--config-path" spotifydConfig "--no-daemon" ];
      UserName = me;
      KeepAlive = true;
      ThrottleInterval = 30;
    };
  };
}
