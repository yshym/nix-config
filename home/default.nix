{ lib, ... }:

{
  imports = [ ./accounts ./packages.nix ./programs ]
    ++ (lib.my.mapModulesRec' ./modules import);
  home.stateVersion = "21.11";
}
