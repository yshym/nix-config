self: super:

with super.pkgs; {
  choose = super.callPackage ./pkg.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };
}
