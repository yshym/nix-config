{ config, lib, pkgs, ... }:

{
  home-manager = {
    # TODO https://github.com/nix-community/home-manager/issues/1262
    sharedModules = [{ manual.manpages.enable = false; }];
    useUserPackages = true;
    useGlobalPkgs = true;
    users.yshym = { pkgs, ... }: {
      imports = [ ./accounts ./packages.nix ./programs ]
        ++ (lib.my.mapModulesRec' ./modules import);
      home.stateVersion = "21.11";
    };
  };
}
