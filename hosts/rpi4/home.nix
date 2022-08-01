{ config, lib, pkgs, ... }:

{
  home-manager.users.yshym = { pkgs, ... }: {
    home.packages = with pkgs; [ elixir erlang ];
    programs = {
      emacs.enable = false;
      zsh.loginExtra = ''ssh-add "$HOME/.ssh/id_ed25519" &> /dev/null'';
    };
  };
}
