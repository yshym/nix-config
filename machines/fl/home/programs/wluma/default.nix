{ config, lib, pkgs, ... }:

{
  systemd.user.services.wluma = let
    me = "yevhenshymotiuk";
    wlumaConfig = "${config.home.homeDirectory}/.config/wluma/config.toml";
  in {
    Unit = {
      Description =
        "Adjusting screen brightness based on screen contents and amount of ambient light";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wluma}/bin/wluma";
      Restart = "always";
      EnvironmentFile = wlumaConfig;
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  home.packages = [ pkgs.wluma ];

  xdg.configFile."wluma/config.toml".source = ./config.toml;
}
