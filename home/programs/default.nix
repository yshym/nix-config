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
    ./topgrade
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
    nodejs = {
      enable = true;
      yarn.enable = true;
    };
    prettier.enable = true;
    python = {
      enable = true;
      black.enable = true;
      mypy.enable = true;
      pylint.enable = true;
      extraPackages = with pkgs.python3Packages; [ python-lsp-server ];
    };
    ranger.enable = true;
    ripgrep.enable = true;
    ruby = {
      enable = false;
      enableBuildLibs = true;
      provider = "nixpkgs";
      enableSolargraph = true;
    };
  };
}
