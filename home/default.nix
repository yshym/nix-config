{ lib, ... }:

{
  imports = [ ./accounts ./packages.nix ./programs ]
    ++ (lib.my.mapModulesRec' ./modules import);
  # HACK https://github.com/nix-community/home-manager/issues/2595
  manual.manpages.enable = false;
  home.stateVersion = "24.11";
}
