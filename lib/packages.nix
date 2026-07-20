{ self, lib, pkgs, ... }:

let
  inherit (lib) foldr intersectLists isList elemAt mapAttrs mapAttrsToList zipAttrs;
  inherit (self.modules) mapModules;
in
{
  # mkWrapper :: package -> postBuild -> derivation
  #
  # Wraps a package (or list of packages) with a postBuild script. The first
  # element of `package` (or `package` itself) names the resulting derivation.
  mkWrapper = package: postBuild:
    let name = if isList package then elemAt package 0 else package;
        paths = if isList package then package else [ package ];
    in pkgs.symlinkJoin {
      inherit paths postBuild;
      name = "${name.pname or name.name or "wrapped"}-wrapped";
      buildInputs = [ pkgs.makeWrapper ];
    };

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
