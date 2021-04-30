{ config, pkgs, ... }:

{
  imports = [
    ./alacritty
    ./asdf.nix
    ./crystal.nix
    ./direnv
    ./emacs
    ./git.nix
    ./hammerspoon
    ./mbsync
    ./nodejs.nix
    ./prettier
    ./python
    ./ranger
    ./ripgrep.nix
    ./ruby.nix
    ./rust
    ./scripts
    ./spotifyd
    ./telegram
    ./topgrade
    ./yabaiScripts
    ./zsh
  ];

  programs = {
    crystal.enable = false;
    emacs = {
      enable = true;
      useHead = false;
    };
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
    topgrade.enable = false;
    ruby = {
      enable = false;
      enableBuildLibs = true;
      provider = "nixpkgs";
      enableSolargraph = true;
    };
  };
}
