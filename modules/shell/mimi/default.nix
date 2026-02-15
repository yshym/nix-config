{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.mimi;
  xdg-utils = (import
    (fetchTarball {
      url = "https://github.com/abathur/nixpkgs/archive/fix_xdg-utils_mimisupport.tar.gz";
      sha256 = "1agvcfkqpgy3h0cqh76zb643wvv368h3sk4dfahsnmf3g46d8szh";
    })
    { system = pkgs.stdenv.system; }).xdg-utils;
in
{
  options.modules.shell.mimi = {
    enable = mkEnableOption "Mimi";
  };

  config = mkIf cfg.enable {
    home = {
      xdg.configFile."mimi/mime.conf".source = ./mime.conf;
    };
    user.packages = with pkgs; [
      file
      (xdg-utils.override { mimiSupport = true; })
    ];
  };
}
