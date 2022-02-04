{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.python.black;
  tomlFormat = pkgs.formats.toml { };
  pythonPackages = pkgs.python3Packages;
in
{
  options.programs.python.black = {
    enable = mkEnableOption "Black code formatter";
    settings = mkOption {
      type = tomlFormat.type;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pythonPackages; [ black ];

    xdg.configFile."black/pyproject.toml".source =
      let black-config.tool.black = cfg.settings; in
      tomlFormat.generate "black-config" black-config;
  };
}
