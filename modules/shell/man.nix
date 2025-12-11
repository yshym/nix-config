{ config, lib, pkgs, ... }:

with lib;
let cfg = config.modules.shell.man;
in
{
  options.modules.shell.man = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ man-pages man-pages-posix ];
  };
}
