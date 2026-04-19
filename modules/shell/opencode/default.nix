{ config, lib, pkgs, ... }:

with lib;
let cfg = config.modules.shell.opencode;
in
{
  options.modules.shell.opencode = {
    enable = mkEnableOption "Opencode";
  };

  config = mkIf cfg.enable {
    home = {
      programs.opencode = {
        enable = true;
        package = pkgs.unstable.opencode;
        settings = {
          default_agent = "plan";
          agent.build.permission.edit = "ask";
          theme = "dracula";
          autoupdate = false;
        };
      };
      home.file = {
        ".agents/skills" = {
          source = ./skills;
          recursive = true;
        };
      };
    };
  };
}
