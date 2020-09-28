{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.python.pylint;
  pythonPackages = pkgs.python3Packages;
in {
  options.programs.python.pylint = { enable = mkEnableOption "Pylint"; };

  config = mkIf cfg.enable {
    home.packages = with pythonPackages; [ pylint pylint-django ];

    xdg.configFile."pylint/pylintrc".source = ./.config/pylint/pylintrc;
    xdg.configFile."pylint/init_hook.py".source = ./.config/pylint/init_hook.py;
  };
}
