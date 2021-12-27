{ config, lib, pkgs, ... }:

let cfg = config.programs.zoxide;
in {
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh.shellAliases.cd = lib.mkIf cfg.enable "z";
}
