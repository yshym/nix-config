{ config, lib, pkgs, ... }:

{
  programs = {
    eza.enable = true;
    zsh.shellAliases.ls = "exa --group-directories-first";
  };
}
