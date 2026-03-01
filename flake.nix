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
      url = "github:yshym/emacs-overlay/2019dddf1777b1aebafbff5f6fe4bac06d134d9e";
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
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.53.3?submodules=1";
      inputs.nixpkgs.follows = "nixos";
    };
    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.53.0.1";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs =
    inputs@{ self, nixos, nixpkgs, flake-utils, emacs-overlay, clion, hyprland, ... }:
    let
      inherit (lib) mapModules mapHosts;
      inherit (flake-utils.lib) eachSystem;

      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      lib = import ./lib {
        inherit inputs;
        pkgs = import nixpkgs { };
        lib = nixpkgs.lib;
      };
    in
    eachSystem
      supportedSystems
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        inherit lib;

        apps.default = {
          type = "app";
          program = ./home/programs/scripts/bin/h;
        };

        devShells.default = pkgs.mkShell {
          shellHook = ''
            export PATH="$(pwd)/home/programs/scripts/bin/h:$PATH"
          '';
        };

        # TODO Filter packages based on a system
        packages = mapModules ./packages (p: pkgs.callPackage p {});
      }) // {
        overlays = {
          emacs = emacs-overlay.overlay;
          clion = clion.overlay;
          hyprland = hyprland.overlays.default;
          hy3 = (final: prev: {
            hy3 = inputs.hy3.packages."${prev.stdenv.system}".hy3;
          });
        };
      } // (mapHosts ./hosts);
}
