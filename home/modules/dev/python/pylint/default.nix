{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.python.pylint;
  pythonPackages = pkgs.python3Packages;
in
{
  options.programs.python.pylint = { enable = mkEnableOption "Pylint"; };

  config = mkIf cfg.enable {
    home.packages = with pythonPackages; [ pylint ];

    xdg.configFile."pylint" = {
      source = ./config;
      recursive = true;
    };
  };
}
