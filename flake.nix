{
  description = "Yevhen's dotfiles";

  inputs = {
    # core
    nixos.url = "github:yshym/nixpkgs/nixos-21.11";
    nixpkgs.url = "github:yshym/nixpkgs/release-21.11";
    nixpkgs-unstable.url = "github:yshym/nixpkgs/nixpkgs-unstable";
    nixpkgs-tdesktop.url = "github:/yshym/nixpkgs/12769bc7e1098fc781f70c40f62c55d4673329fa";
    darwin = {
      url = "github:yshym/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:yshym/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # extra
    emacs-overlay.url = "github:yshym/emacs-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "nixos-hardware/master";
  };

  outputs =
    inputs@{ self, nixos, nixpkgs, darwin, home-manager, flake-utils, ... }:
    let
      inherit (lib) foldr mapAttrs mapAttrsToList nameValuePair zipAttrs;
      inherit (lib.my) isDarwin mapModules mkHost;
      inherit (flake-utils.lib) eachDefaultSystem;

      pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib { inherit inputs pkgs; lib = self; };
      });
      mapPackages = path: mapAttrs
        (_: v: foldr (a: b: a // b) { } v)
        (zipAttrs (mapAttrsToList
          (name: pkg: foldr (a: b: a // b) { }
            (map (plat: { ${plat} = { ${name} = pkg; }; })
              pkg.meta.platforms))
          (mapModules path (p: pkgs.callPackage p { }))));
    in
    eachDefaultSystem
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
      packages = mapPackages ./packages;

      overlays = { emacs = inputs.emacs-overlay.overlay; };

      darwinConfigurations = { mbp16 = mkHost "mbp16" "x86_64-darwin"; };

      nixosConfigurations = {
        rpi4 = mkHost "rpi4" "aarch64-linux";
        fl = mkHost "fl" "x86_64-linux";
      };
    };
}
