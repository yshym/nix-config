{ config, lib, pkgs, ... }:

{
  programs = {
    bat = {
      enable = true;
      config = {
        style = "plain";
        theme = "Dracula";
      };
    };
    zsh.shellAliases.cat = "bat";
  };
}
