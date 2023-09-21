{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.programs.wofi-custom; in
{
  options.programs.wofi-custom = {
    enable = mkEnableOption "Wofi launcher/menu for wlroots based compositors";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ wofi ];

    xdg.configFile."wofi/style.css".source = toCSSFile ./style.sass;
  };
}
