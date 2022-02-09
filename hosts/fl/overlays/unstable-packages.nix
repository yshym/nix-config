{ inputs, lib }:

self: super:
with lib;
let
  pkgs-unstable =
    (import inputs.nixos-unstable { system = super.stdenv.system; });
in
foldr (a: b: a // b) { }
  (map (p: { ${p} = pkgs-unstable.${p}; }) [ "tdesktop" "wluma" ])
