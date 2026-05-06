{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.pi;
  settings = {
    lastChangelogVersion = pkgs.unstable.pi-coding-agent.version;
    defaultProvider = "openrouter";
    defaultModel = "anthropic/claude-opus-4.7";
    theme = "dracula";
    quietStartup = true;
    terminal = { clearOnShrink = true; };
  };
in
{
  options.modules.shell.pi = {
    enable = mkEnableOption "Pi coding agent";
    package = mkPackageOption pkgs "unstable.pi-coding-agent" { };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ unstable.pi-coding-agent ];
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
