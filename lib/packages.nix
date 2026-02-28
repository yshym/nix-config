{ self, lib, pkgs, ... }:

let
  inherit (lib) foldr intersectLists mapAttrs mapAttrsToList zipAttrs;
  inherit (self.modules) mapModules;
in
{
  mapPackages = systems: path: mapAttrs
    (_: v: foldr (a: b: a // b) { } v)
    (zipAttrs (mapAttrsToList
      (name: pkg: foldr (a: b: a // b) { }
        (map (plat: { ${plat} = { ${name} = pkg; }; })
          (intersectLists systems pkg.meta.platforms)))
      (mapModules path (p: pkgs.callPackage p { }))));
}
