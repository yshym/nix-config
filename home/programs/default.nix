{ config, lib, pkgs, ... }:

{
  imports = [ ./git.nix ./zsh ];

  programs = {
    git = {
      enable = true;
      pager = "diff-so-fancy";
    };
  };
}
