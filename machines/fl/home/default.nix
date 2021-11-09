{ config, lib, pkgs, ... }:

{
  home-manager = {
    users.yevhenshymotiuk = { pkgs, ... }: {
      imports = [ ./packages.nix ./wayland ./programs ];
    };
  };
}
