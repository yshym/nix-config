{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.h;
  h = pkgs.callPackage ./_package.nix { };
in {
  options.modules.h = {
    enable = mkEnableOption "h";
  };

  config = mkIf cfg.enable {
    user.packages = [ h ];
  };
}
