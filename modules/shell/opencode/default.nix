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
            default = {
              model = "openrouter/z-ai/glm-5.2";
              disable_reasoning = true;
            };
          };
          theme = "dracula";
          autoupdate = false;
          provider.openrouter.models = {
            "anthropic/claude-opus-5".reasoning = false;
            "z-ai/glm-5.2".reasoning = false;
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
