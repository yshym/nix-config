{
  description = "Yevhen's dotfiles";

  inputs = {
    # core
    nixos.url = "github:yshym/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:yshym/nixpkgs/release-24.05";
    nixpkgs-unstable.url = "github:yshym/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:yshym/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:yshym/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # extra
    emacs-overlay.url = "github:yshym/emacs-overlay/88e410d7f1ddef554b40f66755626e5c883487d9";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "nixos-hardware/master";
    clion = {
      url = "github:yshym/clion";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    undmg-lzma = {
      url = "github:yshym/undmg-lzma/lzma-support";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixos, nixpkgs, flake-utils, emacs-overlay, clion, ... }:
    let
      inherit (lib) foldr intersectLists mapAttrs mapAttrsToList nameValuePair zipAttrs;
      inherit (lib.my) isDarwin mapModules mkHost;
      inherit (flake-utils.lib) eachSystem;

      supportedSystems = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
      # NOTE `<system>` should be replaced with your current host system
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            undmgLzma = inputs.undmg-lzma.defaultPackage."${system}";
          })
        ];
      };
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib { inherit inputs pkgs; lib = self; };
      });
      mapPackages = path: mapAttrs
        (_: v: foldr (a: b: a // b) { } v)
        (zipAttrs (mapAttrsToList
          (name: pkg: foldr (a: b: a // b) { }
            (map (plat: { ${plat} = { ${name} = pkg; }; })
              (intersectLists supportedSystems pkg.meta.platforms)))
          (mapModules path (p: pkgs.callPackage p { }))));
    in
    eachSystem
      supportedSystems
      (system:
      let
        lib = nixpkgs.lib;
        pkgs = import inputs.nixpkgs { inherit system; };
        mylib = import ./lib { inherit inputs lib pkgs; };
      in
      {
        lib = mylib;

        defaultApp = {
          type = "app";
          program = ./home/programs/scripts/bin/h;
        };
      }) // {
      # TODO Consider moving packages to separate overlays
      packages = mapPackages ./packages;

      overlays = {
        emacs = emacs-overlay.overlay;
        clion = clion.overlay;
      };

      darwinConfigurations = { mbp16 = mkHost "mbp16" "aarch64-darwin"; };

      nixosConfigurations = {
        rpi4 = mkHost "rpi4" "aarch64-linux";
        fl = mkHost "fl" "x86_64-linux";
      };
    };
}
