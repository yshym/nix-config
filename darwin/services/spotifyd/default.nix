{ config, lib, pkgs, ... }:

let
  home = config.home-manager.users.yevhenshymotiuk.home;
  spotifydConfig = "${home.homeDirectory}/.config/spotifyd/spotifyd.conf";
in {
  launchd.user.agents = {
    spotifyd.serviceConfig = {
      Label = "rustlang.spotifyd";
      ProgramArguments =
        [ "${pkgs.spotifyd}/bin/spotifyd" "--config-path" spotifydConfig "--no-daemon" ];
      UserName = "yevhenshymotiuk";
      KeepAlive = true;
      ThrottleInterval = 30;
    };
  };
}
