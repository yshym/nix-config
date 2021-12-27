{ config, lib, pkgs, ... }:

let cfg = config.programs.exa;
in {
  programs.exa.enable = true;

  programs.zsh.shellAliases.ls =
    lib.mkIf cfg.enable "exa --group-directories-first";
}
