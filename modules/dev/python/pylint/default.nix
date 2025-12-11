{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.dev.python.pylint;
  pythonPackages = pkgs.python3Packages;
in
{
  options.modules.dev.python.pylint = { enable = mkEnableOption "Pylint"; };

  config = mkIf cfg.enable {
    home.xdg.configFile."pylint/config".source = ./config;
    user.packages = with pythonPackages; [ pylint ];
  };
}
