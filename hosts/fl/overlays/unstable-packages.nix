{ inputs, lib }:

self: super:
with lib;
let
  packageNames = [ "tdesktop" "wluma" ];
  pkgsUnstable =
    (import inputs.nixpkgs-unstable { system = super.stdenv.system; });
in
foldr (a: b: a // b) { }
  (map (p: { ${p} = pkgsUnstable.${p}; }) packageNames)
