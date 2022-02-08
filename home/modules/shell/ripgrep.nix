{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.ripgrep;
in
{
  options.programs.ripgrep = {
    enable = mkEnableOption "Ripgrep line-oriented CLI search tool";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ripgrep ];

    xdg.configFile.ripgrep = {
      target = "ripgrep/config";
      text = ''
        --max-columns=150
        --max-columns-preview
        --type-add
        web:*.{html,css,js}*
        --smart-case
      '';
    };

    programs.zsh.shellAliases.grep = "rg -i";
  };
}
