{ config, pkgs, ... }:

{
  launchd.user.agents = {
    sortdir.serviceConfig = {
      ProgramArguments = [ "${pkgs.my.sortdir}/bin/sortdir" ];
      UserName = "${config.user.name}";
      KeepAlive = true;
      ThrottleInterval = 30;
    };
  };
}
