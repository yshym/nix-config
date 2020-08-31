{ config, pkgs, ... }: {
  imports = [
    ./doom
    ./zsh
  ];

  programs = {
    doom.enable = true;
    emacs = { 
      enable = true;
      # package = pkgs.emacsMacport;
    };
    go.enable = true;
    zsh.enable = true;
  };
}
