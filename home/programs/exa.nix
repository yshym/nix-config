{ config, lib, pkgs, ... }:

{
  programs = {
    eza.enable = true;
    zsh.shellAliases.ls = "eza --group-directories-first";
  };
}
