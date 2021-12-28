{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty
    ./asdf.nix
    ./bat.nix
    ./direnv
    ./emacs
    ./exa.nix
    ./firefox
    ./git.nix
    ./go.nix
    ./nodejs.nix
    ./prettier
    ./python
    ./ranger
    ./ripgrep.nix
    ./ruby.nix
    ./rust
    ./scripts
    ./topgrade
    ./vim.nix
    ./zathura.nix
    ./zoxide.nix
    ./zsh
  ];

  programs = {
    emacs.enable = true;
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
      extraPackages = with pkgs.python3Packages; [
        codecov
        grip
        jedi
        # python-lsp-server
      ];
      black.enable = true;
      mypy.enable = true;
      pipx.enable = true;
      pylint.enable = true;
    };
    ruby = {
      enable = false;
      enableBuildLibs = true;
      provider = "nixpkgs";
      enableSolargraph = true;
    };
  };
}
