{ inputs, lib, pkgs }:

let
  inherit (lib) makeExtensible attrValues foldr;
  inherit (modules) mapModules;

  modules = import ./modules.nix {
    inherit lib;
    self.attrs = import ./attrs.nix {
      inherit lib;
      self = { };
    };
  };

  mylib = makeExtensible (self:
    let callLibs = file: import file { inherit self inputs lib pkgs; };
    in mapModules ./. callLibs);
in
mylib.extend (self: super: foldr (a: b: a // b) { } (attrValues super))
