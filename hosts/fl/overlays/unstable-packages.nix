{ inputs, lib }:

self: super:
with lib;
let
  pkgs-unstable =
    (import inputs.nixpkgs-unstable { system = super.stdenv.system; });
in
foldr (a: b: a // b) { }
  (map (p: { ${p} = pkgs-unstable.${p}; }) [ "tdesktop" "wluma" ])
