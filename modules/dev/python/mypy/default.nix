{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.dev.python.mypy;
  tomlFormat = pkgs.formats.toml { };
  pythonPackages = pkgs.python3Packages;
in
{
  options.modules.dev.python.mypy = {
    enable = mkEnableOption "Mypy: Optional Static Typing for Python";
    settings = mkOption {
      type = tomlFormat.type;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.xdg.configFile."mypy/config".source =
      let mypy-config.mypy = cfg.settings; in
      tomlFormat.generate "mypy-config" mypy-config;
    user.packages = with pythonPackages; [ mypy ];
  };
}
