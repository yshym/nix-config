{ config, lib, pkgs, ... }:

{
  programs.topgrade = {
    enable = true;
    settings = {
      only = [
        "git_repos"
        "tldr"
      ];
      git.repos = [ "~/.emacs.d" ];
    };
  };
}
