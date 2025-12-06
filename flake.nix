{
  description = "Yevhen's dotfiles";

  inputs = {
    # core
    nixos.url = "github:yshym/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:yshym/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:yshym/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:yshym/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:yshym/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # extra
    emacs-overlay = {
      url = "github:yshym/emacs-overlay/f87351a238ddda570226360a8e0725fc2d75f273";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "nixos-hardware/master";
    nixos-apple-silicon.url = "github:tpwrules/nixos-apple-silicon/releasep2-2024-12-25";
    clion = {
      url = "github:yshym/clion";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    undmg-lzma = {
      url = "github:yshym/undmg-lzma/lzma-support";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
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
      system = "aarch64-darwin";
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

        apps.default = {
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
        atlas = mkHost "atlas" "aarch64-linux";
      };
    };
}
