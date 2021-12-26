{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty
    ./asdf.nix
    ./crystal.nix
    ./direnv
    ./emacs
    ./firefox
    ./git.nix
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
    ./zsh
  ];

  programs = {
    crystal.enable = false;
    emacs.enable = true;
    git = {
      enable = true;
      pager = "diff-so-fancy";
    };
    go.enable = true;
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
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
