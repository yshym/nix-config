{ config, lib, pkgs, mv, ... }:

with lib;
let
  cfg = config.modules.shell.pi;
  pkg = mv.versions.pi-coding-agent."0.85.1";
  settings = {
    lastChangelogVersion = pkg.version;
    defaultProvider = "openrouter";
    defaultModel = "deepseek/deepseek-v4.1-flash";
    defaultThinkingLevel = "off";
    hideThinkingBlock = true;
    theme = "dracula";
    quietStartup = true;
    terminal = { clearOnShrink = true; };
  };
in
{
  options.modules.shell.pi = {
    enable = mkEnableOption "Pi coding agent";
    package = mkPackageOption pkgs "pi-coding-agent" { };
  };

  config = mkIf cfg.enable {
    user.packages = [ pkg ];
    home = {
      xdg.configFile = {
        "pi/themes/dracula.json".source = ./dracula.json;
        "pi/extensions".source = ./extensions;
        "pi/settings.json".text = builtins.toJSON settings;
      };
      home.sessionVariables = {
        PI_CODING_AGENT_DIR = "~/.config/pi";
        # Skip the "update available" banner on startup
        PI_SKIP_VERSION_CHECK = "1";
      };
    };
  };
}
