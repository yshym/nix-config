{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.topgrade;
in {
  options.programs.topgrade = {
    enable = mkEnableOption "topgrade";

    config = mkOption {
      default = { };
      example = {
        git_repos = [ "~/.emacs.d" ];
        disable = [ "emacs" "gem" ];
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [ topgrade ]
      ++ (optional (attrByPath [ "run_in_tmux" ] false cfg.config) tmux);

    xdg.configFile."topgrade.toml".source = ./.config/topgrade.toml;
  };
}
