{ config, lib, pkgs, mv, ... }:

with lib;
let
  cfg = config.modules.shell.pi;
  pkg = mv.versions.pi-coding-agent."1.1.0";
  pi-subagents = import ./_pi-subagents.nix {
    inherit lib;
    inherit (pkgs) buildNpmPackage fetchFromGitHub;
  };
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
        "pi/settings.json".text = builtins.toJSON (settings // {
          packages = [
            # Vendored via Nix: the published package needs its runtime deps
            # (croner, nanoid) present, which pi does not install for local sources.
            "${pi-subagents}/lib/node_modules/@tintinweb/pi-subagents"
          ];
        });
      };
      home.sessionVariables = {
        PI_CODING_AGENT_DIR = "~/.config/pi";
        # Skip the "update available" banner on startup
        PI_SKIP_VERSION_CHECK = "1";
      };
    };
  };
}
