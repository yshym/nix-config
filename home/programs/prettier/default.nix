{ config, lib, pkgs, ... }:
with lib;
let cfg = config.programs.prettier;
in {
  options.programs.prettier = { enable = mkEnableOption "Prettier"; };

  config = mkIf cfg.enable {
    home.file.".prettierrc.toml".source = ./.config/prettier/prettierrc.toml;
  };
}
