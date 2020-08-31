{ config, pkgs, ... }: {
  imports = [
    ./zsh
  ];

  programs = {
    go.enable = true;
    zsh.enable = true;
  };
}
