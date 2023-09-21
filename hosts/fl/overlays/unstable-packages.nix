{ inputs, lib }:

self: super:
with lib;
let
  system = super.stdenv.system;
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
  packageNames = [ "discord-ptb" "slack" "tdesktop" "wluma" ];
in
foldr (a: b: a // b) { }
  (map (p: { ${p} = pkgsUnstable.${p}; }) packageNames)
