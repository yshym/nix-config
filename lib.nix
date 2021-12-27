{ inputs, lib, pkgs, ... }:

rec {
  isDarwin = system: lib.strings.hasSuffix "darwin" system;
  mkPkgs = system:
    import (if isDarwin system then inputs.nixpkgs else inputs.nixos) {
      inherit system;
    };
  mkHost = host: system:
    with mkPkgs system;
    (if isDarwin system then
      inputs.darwin.lib.darwinSystem
    else
      inputs.nixos.lib.nixosSystem) {
        system = system;
        modules = [
          inputs.home-manager."${
            if isDarwin system then "darwin" else "nixos"
          }Modules".home-manager
          (import ./. {
            inherit inputs;
            pkgs = mkPkgs system;
          })
          (./machines + "/${host}")
        ];
      };
}
