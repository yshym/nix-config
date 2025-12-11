{ config, ... }:

{
  home = { pkgs, ... }: {
    home.packages = with pkgs; [ elixir erlang ];
    programs = {
      zsh.loginExtra = ''ssh-add "$HOME/.ssh/id_ed25519" &> /dev/null'';
    };
  };
}
