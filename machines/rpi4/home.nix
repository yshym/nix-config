{ config, lib, pkgs, ... }:

{
  home-manager.users.yshym = { pkgs, ... }: {
    home.packages = with pkgs; [ elixir erlang ];
    programs = {
      git.gpgKey = "1646BDE9047380DF";
      zsh.loginExtra = ''ssh-add "$HOME/.ssh/id_ed25519" &> /dev/null'';
    };
  };
}
