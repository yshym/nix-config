{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty
    ./asdf.nix
    ./crystal.nix
    ./direnv
    ./git.nix
    ./nodejs.nix
    ./prettier
    ./python
    ./ranger
    ./ripgrep.nix
    ./ruby.nix
    ./rust
    ./topgrade
    ./zathura.nix
    ./zsh
  ];

  programs = {
    crystal.enable = false;
    git = {
      enable = true;
      pager = "diff-so-fancy";
    };
    go.enable = true;
    nodejs = {
      enable = true;
      yarn.enable = true;
    };
    python = {
      enable = true;
      extraPackages = with pkgs.python3Packages; [ codecov grip jedi poetry ];
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
