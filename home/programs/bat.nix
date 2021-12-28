{ config, lib, pkgs, ... }:

{
  programs = {
    bat.enable = true;
    zsh.shellAliases.cat = "bat --style plain";
  };
}
