{ config, pkgs, ... }: {
  imports = [
    ./zsh
  ];

  programs = {
    zsh.enable = true;
  };
}
