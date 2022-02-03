{ inputs, lib, pkgs, ... }:

with lib; rec {
  isDarwin = system: strings.hasSuffix "darwin" system;
  mkPkgs = system:
    import (if isDarwin system then inputs.nixpkgs else inputs.nixos) {
      inherit system;
      config.allowUnfree = true;
      overlays = [ (final: prev: { my = inputs.self.packages."${system}"; }) ]
        ++ (attrValues inputs.self.overlays);
    };
  mkHost = host: system:
    let
      pkgs = mkPkgs system;
      hostPath = ../machines + "/${host}";
    in (if isDarwin system then
      inputs.darwin.lib.darwinSystem
    else
      inputs.nixos.lib.nixosSystem) {
        inherit system;
        specialArgs = { inherit lib inputs; };
        modules = [
          {
            nixpkgs.pkgs = pkgs;
            networking.hostName = mkDefault (removeSuffix ".nix" host);
          }
          inputs.home-manager."${
            if isDarwin system then "darwin" else "nixos"
          }Modules".home-manager
          {
            home-manager = {
              # TODO https://github.com/nix-community/home-manager/issues/1262
              sharedModules = [{ manual.manpages.enable = false; }];
              useUserPackages = true;
              useGlobalPkgs = true;
              users.yshym = import ../home { inherit lib; };
            };
          }
          ../.
          hostPath
        ];
      };
}
