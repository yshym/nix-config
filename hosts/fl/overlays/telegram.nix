{ inputs }:

self: super:
let
  pkgs-unstable =
    (import inputs.nixpkgs-unstable { system = super.stdenv.system; });
in
{ tdesktop = pkgs-unstable.tdesktop; }
