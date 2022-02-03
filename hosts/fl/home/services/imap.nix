{ config, lib, pkgs, ... }:

{
  systemd.user.services = {
    proton-bridge = {
      Unit.Description = "proton-bridge";
      Service = {
        ExecStart =
          "${pkgs.protonmail-bridge}/bin/protonmail-bridge --no-window";
        Restart = "always";
        RestartSec = 30;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
