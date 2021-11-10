{ config, lib, pkgs, ... }:

with lib;
with pkgs;
let cfg = config.programs.direnv;
in {
  programs.direnv = {
    enable = true;
    enableZshIntegration = false;
    nix-direnv.enable = true;
    config = {
      whitelist = {
        prefix = [ "${config.home.homeDirectory}/dev" ];
        exact = [ "/etc/nixos" ];
      };
    };
    stdlib = ''
      layout_poetry() {
        if [[ ! -f pyproject.toml ]]; then
          log_error 'No pyproject.toml found. Use `poetry new` or `poetry init` to create one first.'
          exit 2
        fi

        # create venv if it doesn't exist
        poetry run true

        export VIRTUAL_ENV=$(poetry env info --path)
        export POETRY_ACTIVE=1
        PATH_add "$VIRTUAL_ENV/bin"
      }
    '';
  };
}
