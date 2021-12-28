{ config, lib, pkgs, ... }:

{
  programs = {
    exa.enable = true;
    zsh.shellAliases.ls = "exa --group-directories-first";
  };
}
