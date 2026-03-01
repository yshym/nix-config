{ self, lib, pkgs, ... }:

let
  inherit (lib) foldr intersectLists mapAttrs mapAttrsToList zipAttrs;
  inherit (self.modules) mapModules;
in
{
  # mapPackages :: [string] -> path -> { ${system} :: { ${name} :: derivation; }; }
  #
  # Builds all packages from .nix files in a directory via callPackage, then
  # distributes them across systems based on each package's meta.platforms,
  # producing the attrset shape expected by the flake packages output.
  mapPackages = systems: path: mapAttrs
    (_: v: foldr (a: b: a // b) { } v)
    (zipAttrs (mapAttrsToList
      (name: pkg: foldr (a: b: a // b) { }
        (map (plat: { ${plat} = { ${name} = pkg; }; })
          (intersectLists systems pkg.meta.platforms)))
      (mapModules path (p: pkgs.callPackage p { }))));
}
