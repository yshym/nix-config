{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.dev.python.black;
  tomlFormat = pkgs.formats.toml { };
  pythonPackages = pkgs.python3Packages;
in
{
  options.modules.dev.python.black = {
    enable = mkEnableOption "Black code formatter";
    settings = mkOption {
      type = tomlFormat.type;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.xdg.configFile."black/pyproject.toml".source =
      let black-config.tool.black = cfg.settings; in
      tomlFormat.generate "black-config" black-config;
    user.packages = with pythonPackages; [ black ];
  };
}
