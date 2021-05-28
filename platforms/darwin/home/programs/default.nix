{ config, pkgs, ... }:

{
  imports = [
    ./alacritty
    ./asdf.nix
    ./crystal.nix
    ./direnv
    ./emacs
    ./firefox
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
    ./spotify
    ./telegram
    ./topgrade
    ./yabai
  ];

  programs = {
    crystal.enable = false;
    emacs = {
      enable = true;
      useHead = false;
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
