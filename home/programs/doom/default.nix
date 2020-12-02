{ config, lib, pkgs, ... }:
with lib;
let cfg = config.programs.doom;
in {
  options.programs.doom = {
    enable = mkEnableOption "Doom emacs config";
  };

  config = mkIf cfg.enable {
    programs = {
      zsh = {
        envExtra = ''
          export PATH="$HOME/.emacs.d/bin:$PATH"
        '';
        sessionVariables.EDITOR = "emacsclient";
      };
    };

    home.file = {
      ".doom.d" = {
        source = ./.doom.d;
        recursive = true;
      };
    };
  };
}
