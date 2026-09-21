{ config, lib, pkgs, mv, ... }:

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
        package = mv.versions.opencode."1.18.13";
        settings = {
          default_agent = "plan";
          agent = {
            build.permission.edit = "ask";
            default.model = "openrouter/deepseek/deepseek-v4.1-flash";
          };
          theme = "dracula";
          autoupdate = false;
          tui.display_thinking = "none";
          provider.amazon-bedrock.options = {
            region = "us-west-2";
            profile = "claude-code-bedrock-sso";
          };
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
