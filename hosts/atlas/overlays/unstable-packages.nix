{ inputs, lib }:

self: super:
{
  unstable = import inputs.nixpkgs-unstable {
    system = super.stdenv.system;
    config.allowUnfree = true;
  };
}
