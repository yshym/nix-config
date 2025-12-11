{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.dev.prettier;
in
{
  options.modules.dev.prettier = { enable = mkEnableOption "Prettier"; };

  config = mkIf cfg.enable {
    home.home.file.".prettierrc.toml".source = .config/prettier/prettierrc.toml;
    user.packages = with pkgs; [ nodePackages.prettier ];
  };
}
