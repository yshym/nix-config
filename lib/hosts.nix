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
      hostPath = ../hosts + "/${host}";
      shortSystemName = if isDarwin system then "darwin" else "nixos";
      systemModule = inputs.${shortSystemName}.lib."${shortSystemName}System";
      hmModule = inputs.home-manager."${shortSystemName}Modules".home-manager;
    in
    systemModule {
      inherit system;
      specialArgs = { inherit lib inputs; };
      modules = [
        {
          nixpkgs.pkgs = pkgs;
          networking.hostName = mkDefault (removeSuffix ".nix" host);
        }
        hmModule
        {
          home-manager = {
            extraSpecialArgs.mylib = lib.my;
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
