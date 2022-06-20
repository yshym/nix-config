{ ... }:

self: super:
{
  clion = super.callPackage ./pkg.nix { };
}
