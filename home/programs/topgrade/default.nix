{ config, lib, pkgs, ... }:

let cfg = config.programs.topgrade;
in {
  programs.topgrade = {
    enable = true;
    settings = {
      only = [ "git_repos" "tldr" ];
      git.repos = [ "~/.emacs.d" ];
    };
  };

  programs.zsh.shellAliases.tg = lib.mkIf cfg.enable "topgrade -y";
}
