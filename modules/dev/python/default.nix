{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.dev.python;
  python = pkgs.python3;
  myPythonPackages = pythonPackages:
    with pythonPackages; [
      # setup
      pip
      setuptools
      wheel

      # ipython
      ipdb

      # other
      pkgs.clion
    ];
  pythonWithMyPackages = python.withPackages myPythonPackages;
in
{
  options.modules.dev.python = {
    enable = mkEnableOption "Python language support";
    extraPackages = mkOption {
      default = [ ];
      type = with types; listOf package;
    };
  };

  config = mkIf cfg.enable {
    home = {
      programs.zsh.envExtra = ''
        export PYTHONPATH="${pythonWithMyPackages}/${pythonWithMyPackages.sitePackages}:$PYTHONPATH"
        export PYTHONBREAKPOINT=ipdb.set_trace
      '';
      home.file.".pdbrc".source = ./.pdbrc;
    };
    user.packages = [ pythonWithMyPackages ] ++ cfg.extraPackages;
  };
}
