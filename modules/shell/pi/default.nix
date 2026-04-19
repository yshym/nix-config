{ config, lib, pkgs, ... }:

with lib;
let cfg = config.modules.shell.pi;
in
{
  options.modules.shell.pi = {
    enable = mkEnableOption "Pi coding agent";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ unstable.pi-coding-agent ];
    home = {
      xdg.configFile = {
        "pi/themes/dracula.json".source = ./dracula.json;
        "pi/extensions".source = ./extensions;
      };
      home.sessionVariables.PI_CODING_AGENT_DIR = "~/.config/pi";
    };
  };
}
