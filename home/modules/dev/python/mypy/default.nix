{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.python.mypy;
  tomlFormat = pkgs.formats.toml { };
  pythonPackages = pkgs.python3Packages;
in
{
  options.programs.python.mypy = {
    enable = mkEnableOption "Mypy: Optional Static Typing for Python";
    settings = mkOption {
      type = tomlFormat.type;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pythonPackages; [ mypy ];

    xdg.configFile."mypy/config".source =
      let mypy-config.mypy = cfg.settings; in
      tomlFormat.generate "mypy-config" mypy-config;
  };
}
