{ pkgs, ... }:

{
  nixpkgs.overlays =
    [ (self: super: { Firefox = super.callPackage ./pkg.nix { }; }) ];

  programs.firefox.package = pkgs.Firefox;
}
