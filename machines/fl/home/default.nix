{ config, lib, pkgs, ... }:

{
  home-manager = {
    users.yshym = { pkgs, ... }: {
      imports = [ ./packages.nix ./themes.nix ./wayland ./programs ./services ];
    };
  };
}
