{ inputs, lib, pkgs, ... }:

rec {
  isDarwin = system: lib.strings.hasSuffix "darwin" system;
  mkPkgs = system:
    import (if isDarwin system then inputs.nixpkgs else inputs.nixos) {
      inherit system;
    };
  mkHost = host: system:
    let pkgs = mkPkgs system;
    in with pkgs;
    (if isDarwin system then
      inputs.darwin.lib.darwinSystem
    else
      inputs.nixos.lib.nixosSystem) {
        inherit system;
        specialArgs = { inherit lib inputs; };
        modules = [
          inputs.home-manager."${
            if isDarwin system then "darwin" else "nixos"
          }Modules".home-manager
          ../.
          (../machines + "/${host}")
        ];
      };
}
