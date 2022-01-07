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
        system = system;
        modules = let config = (import ./. { inherit inputs pkgs; });
        in [
          inputs.home-manager."${
            if isDarwin system then "darwin" else "nixos"
          }Modules".home-manager
          config
          (import (./machines + "/${host}") { inherit inputs config lib pkgs; })
        ];
      };
}
