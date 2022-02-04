{ pkgs, lib, ... }:

let
  cachesDir = ./caches;
  attrsToPath = name: value: cachesDir + ("/" + name);
  filterCaches = key: value: value == "regular" && lib.hasSuffix ".nix" key;
  imports = lib.mapAttrsToList attrsToPath
    (lib.filterAttrs filterCaches (builtins.readDir cachesDir));
in
{
  environment.systemPackages = [ pkgs.cachix ];

  inherit imports;
  nix.binaryCaches = [ "https://cache.nixos.org/" ];
}
