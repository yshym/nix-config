{ config, lib, pkgs, ... }:

{
  imports = [ ./git.nix ];

  programs = {
    git = {
      enable = true;
      pager = "diff-so-fancy";
    };
  };
}
