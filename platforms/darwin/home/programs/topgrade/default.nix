{ config, lib, pkgs, ... }:

{
  programs.topgrade = {
    enable = false;
    settings = {
      disable = [
        "cargo"
        "deno"
        "emacs"
        "flutter"
        "gem"
        "node"
        "pipx"
        "rustup"
        "system"
      ];
      git.repos = [ "~/.emacs.d" ];
    };
  };
}
