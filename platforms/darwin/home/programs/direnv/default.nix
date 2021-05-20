{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.direnv;
in {
  programs.direnv = {
    enable = true;
    config = {
      whitelist = {
        prefix = [ "${config.home.homeDirectory}/dev" ];
        exact = [ "/etc/nixos" ];
      };
    };
  };

  home = mkIf cfg.enable { file.".direnvrc".source = ./direnvrc; };
}
