{ config, pkgs, ... }:

let
  spotifydConfig = "${config.user.home}/.config/spotifyd/spotifyd.conf";
in
{
  launchd.user.agents = {
    spotifyd.serviceConfig = {
      ProgramArguments =
        [ "${pkgs.spotifyd}/bin/spotifyd" "--config-path" spotifydConfig "--no-daemon" ];
      UserName = config.user.name;
      KeepAlive = true;
      ThrottleInterval = 30;
    };
  };
}
