{ config, lib, pkgs, ... }:

let cfg = config.programs.bat;
in {
  programs.bat.enable = true;

  programs.zsh.shellAliases.cat = lib.mkIf cfg.enable "bat --style plain";
}
