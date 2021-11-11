{ config, lib, pkgs, ... }:

{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.yevhenshymotiuk = { pkgs, ... }: {
      imports = [ ./packages.nix ./programs ];
      home.stateVersion = "21.05";
    };
  };
}
