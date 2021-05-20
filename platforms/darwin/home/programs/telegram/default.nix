{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays =
    [ (self: super: { Telegram = super.callPackage ./pkg.nix { }; }) ];

  home.file."Library/Application Support/Telegram Desktop/tdata/shortcuts-custom.json".source =
    ./shortcuts-custom.json;
  home.packages = [ pkgs.Telegram ];
}
