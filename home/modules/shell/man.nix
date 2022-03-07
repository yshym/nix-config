{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.man;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ man-pages man-pages-posix ];
  };
}
