{ self, inputs, lib, ... }:

with builtins;
with lib;
rec {
  isDarwin = system: strings.hasSuffix "darwin" system;
  mkPkgs = system:
    import (if isDarwin system then inputs.nixpkgs else inputs.nixos) {
      inherit system;
      config.allowUnfree = true;
      overlays = [ (final: prev: { my = inputs.self.packages."${system}"; }) ]
        ++ (attrValues inputs.self.overlays);
    };
  mkHost = host:
    let
      hostPath = ../hosts + "/${host}";
      system = (import hostPath { inherit inputs lib; pkgs = {}; }).system;
      pkgs = mkPkgs system;
      lib = inputs.nixpkgs.lib.extend (_: _: {
        my = self;
      });
      shortSystemName = if isDarwin system then "darwin" else "nixos";
      systemModule = inputs."${shortSystemName}".lib."${shortSystemName}System";
      hmModule = inputs.home-manager."${shortSystemName}Modules".home-manager;
      hostConfigRaw = import hostPath { inherit inputs lib pkgs; };
      # Remove custom `system` attr to avoid collision with the default `system` attr
      hostConfig = removeAttrs hostConfigRaw ["system"];
    in
    systemModule {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        {
          nixpkgs =
            if isDarwin system then {
              config = pkgs.config;
              overlays = pkgs.overlays;
            } else { pkgs = pkgs; };
          networking.hostName = mkDefault (removeSuffix ".nix" host);
        }
        hmModule
        {
          home-manager = {
            extraSpecialArgs = {
              lib = inputs.nixpkgs.lib.extend
                (self: super: inputs.home-manager.lib // lib);
            };
            useUserPackages = true;
            useGlobalPkgs = true;
            users."${hostConfig.user.name}" = import ../home { inherit lib; };
          };
        }
        hostConfig
        ../.
      ];
    };
}
