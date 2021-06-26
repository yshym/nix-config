{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.python.mypy;
  pythonPackages = pkgs.python3Packages;
in {
  options.programs.python.mypy = {
    enable = mkEnableOption "Mypy: Optional Static Typing for Python";
  };

  config = mkIf cfg.enable {
    home.packages = with pythonPackages; [ mypy ];

    xdg.configFile."mypy/config".source = ./.config/mypy/config;
  };
}
