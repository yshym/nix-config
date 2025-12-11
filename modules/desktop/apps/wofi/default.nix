{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.wofi-custom; in
{
  options.modules.desktop.apps.wofi-custom = {
    enable = mkEnableOption "Wofi launcher/menu for wlroots based compositors";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ wofi ];
      xdg.configFile."wofi/style.css".source = toCSSFile ./style.sass;
    };
  };
}
