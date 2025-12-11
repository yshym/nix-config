{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.dev.rust;
in
{
  options.modules.dev.rust = {
    enable = mkEnableOption "Rust language support";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ rustup ];
      programs.zsh.envExtra = ''
        export PATH="$HOME/.cargo/bin:$PATH"
      '';
    };
  };
}
