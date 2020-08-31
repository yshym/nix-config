{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.python.pipx;
  pythonPackages = pkgs.python3Packages;
in {
  options.programs.python.pipx = {
    enable = mkEnableOption "pipx package manager";
  };

  config = mkIf cfg.enable {
    home.packages = with pythonPackages; [ pipx ];
  };
}
