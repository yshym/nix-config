{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty
    ./bat.nix
    ./direnv
    ./exa.nix
    ./firefox
    ./go.nix
    ./password-store.nix
    ./scripts
    ./tmux
    # ./topgrade
    ./vim.nix
    ./zathura.nix
    ./zoxide.nix
    ./zsh
  ];

  programs = {
    ripgrep = {
      enable = true;
      # NOTE Arguments break ripgrep in Emacs
      # arguments = [
      #   "--max-columns=150"
      #   "--max-columns-preview"
      #   "--type-add web:*.{html,css,js}*"
      #   "--smart-case"
      # ];
    };
    fzf = {
      enable = true;
      colors = {
        "pointer" = "#BD93F9";
        "prompt"= "#50fa7b";
      };
    };
  };
}
