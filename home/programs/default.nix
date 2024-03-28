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
    ./spotify
    # ./topgrade
    ./vim.nix
    ./zathura.nix
    ./zoxide.nix
    ./zsh
  ];

  programs = {
    git = {
      enable = true;
      pager = "diff-so-fancy";
    };
    man.enable = true;
    nodejs = {
      enable = true;
      yarn.enable = true;
    };
    prettier.enable = true;
    python = {
      enable = true;
      black = {
        enable = false;
        settings.line-length = 79;
      };
      mypy = {
        enable = true;
        settings.ignore_missing_imports = true;
      };
      pylint.enable = false;
      extraPackages = with pkgs.python3Packages; [ python-lsp-server ];
    };
    ranger.enable = true;
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
    ruby = {
      enable = false;
      enableBuildLibs = true;
      provider = "nixpkgs";
      enableSolargraph = true;
    };
  };
}
