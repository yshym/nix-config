{ config, lib, pkgs, ... }:

with builtins;
with lib;
with pkgs; {
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = false;
      nix-direnv.enable = true;
      config = {
        whitelist = {
          prefix = [ "${config.home.homeDirectory}/dev" ];
          exact = [ "/etc/nixos" ];
        };
      };
      stdlib = readFile ./direnvrc;
    };
    zsh.shellAliases = {
      dhook = ''eval "$(direnv hook zsh)"'';
      drel = "direnv reload";
    };
  };
}
