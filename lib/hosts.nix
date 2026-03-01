{ self, inputs, lib, ... }:

with builtins;
with lib;
rec {
  # getSystem :: path -> string
  #
  # Reads the system string from a host's default.nix by importing it with
  # dummy config and pkgs arguments. Relies on Nix's laziness to avoid
  # evaluating anything beyond the top-level `system` attribute.
  getSystem = hostPath: (import hostPath { inherit inputs lib; config = {}; pkgs = {}; }).system;

  # isDarwin :: string -> bool
  #
  # Returns true if the system string is a Darwin (macOS) platform.
  isDarwin = system: strings.hasSuffix "darwin" system;

  # mkPkgs :: string -> pkgs
  #
  # Imports the appropriate nixpkgs (darwin or nixos) for the given system string,
  # with allowUnfree and all configured overlays applied.
  mkPkgs = system:
    import (if isDarwin system then inputs.nixpkgs else inputs.nixos) {
      inherit system;
      config.allowUnfree = true;
      overlays = [ (final: prev: { my = inputs.self.packages."${system}"; }) ]
        ++ (attrValues inputs.self.overlays);
    };

  # mkHost :: string -> system-configuration
  #
  # Builds a full NixOS or nix-darwin system configuration for the named host.
  # Reads the host's system from its config, sets up nixpkgs, home-manager,
  # and all platform-specific modules.
  mkHost = host:
    let
      hostPath = ../hosts + "/${host}";
      system = getSystem(hostPath);
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
