{ inputs }:

self: super:
let
  pkgs-unstable =
    (import inputs.nixos-unstable { system = super.stdenv.system; });
in { wluma = pkgs-unstable.wluma; }
