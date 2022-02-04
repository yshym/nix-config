{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.ranger;
in
{
  options.programs.ranger = { enable = mkEnableOption "Ranger file manager"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ranger w3m-full ];

    xdg.configFile = {
      "ranger/rc.conf".source = ./rc.conf;
      "ranger/rifle.conf".source = ./rifle.conf;
    };
  };
}
