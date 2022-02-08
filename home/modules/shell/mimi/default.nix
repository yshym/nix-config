{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.mimi; in
{
  options.programs.mimi = {
    enable = mkEnableOption "Mimi";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      file
      (xdg-utils.override { mimiSupport = true; })
    ];

    xdg.configFile."mimi/mime.conf".source = ./mime.conf;
  };
}
