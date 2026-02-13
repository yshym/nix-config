{ config, lib, pkgs, ... }:

with lib;
let cfg = config.modules.shell.git;
in
{
  options.modules.shell.opencode = {
    enable = mkEnableOption "Opencode";
  };

  config = mkIf cfg.enable {
    home.programs.opencode = {
      enable = true;
      package = pkgs.unstable.opencode;
      settings = {
        theme = "dracula";
        autoupdate = false;
      };
    };
  };
}
