{ pkgs, ... }:

{
  nixpkgs.overlays =
    [ (self: super: { Brave = super.callPackage ./pkg.nix { }; }) ];

  home.packages = [ pkgs.Brave ];
  programs.zsh.sessionVariables.BROWSER = "brave";
}
