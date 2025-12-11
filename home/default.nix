{ lib, ... }:

{
  imports = [ ./accounts ./packages.nix ./programs ];
  # HACK https://github.com/nix-community/home-manager/issues/2595
  manual.manpages.enable = false;
  home.stateVersion = "25.11";
}
