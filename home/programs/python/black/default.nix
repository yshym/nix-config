{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.python.black;
  pythonPackages = pkgs.python3Packages;
in {
  options.programs.python.black = {
    enable = mkEnableOption "Black code formatter";
  };

  config = mkIf cfg.enable {
    home.packages = with pythonPackages; [ black ];

    xdg.configFile."black/pyproject.toml".source =
      ./.config/black/pyproject.toml;
  };
}
