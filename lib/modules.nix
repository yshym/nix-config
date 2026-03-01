{ self, inputs, lib, ... }:

let
  inherit (builtins) attrValues readDir pathExists concatLists;
  inherit (lib)
    id mapAttrsToList filterAttrs hasPrefix hasSuffix nameValuePair
    removeSuffix;
  inherit (self.attrs) mapFilterAttrs;
  inherit (self.hosts) getSystem isDarwin mkHost;
in
rec {
  # mapModules :: path -> (path -> a) -> attrs
  #
  # Discovers .nix files and directories (with default.nix) in a directory,
  # applies fn to each path, and returns an attrset keyed by module name.
  # Skips default.nix, flake.nix, and entries prefixed with "_".
  mapModules = dir: fn:
    mapFilterAttrs (n: v: v != null && !(hasPrefix "_" n))
      (n: v:
        let path = "${toString dir}/${n}"; in
        if v == "directory" && pathExists "${path}/default.nix"
        then nameValuePair n (fn path)
        else if v == "regular" &&
                n != "default.nix" &&
                n != "flake.nix" &&
                hasSuffix ".nix" n
        then nameValuePair (removeSuffix ".nix" n) (fn path)
        else nameValuePair "" null)
      (readDir dir);

  # mapModules' :: path -> (path -> a) -> [a]
  #
  # Like mapModules, but returns a list of values instead of an attrset.
  mapModules' = dir: fn: attrValues (mapModules dir fn);

  # mapModulesRec :: path -> (path -> a) -> attrs
  #
  # Like mapModules, but recurses into subdirectories, producing a nested attrset.
  mapModulesRec = dir: fn:
    mapFilterAttrs (n: v: v != null && !(hasPrefix "_" n))
      (n: v:
        let path = "${toString dir}/${n}"; in
        if v == "directory"
        then nameValuePair n (mapModulesRec path fn)
        else if v == "regular" &&
                n != "default.nix" &&
                hasSuffix ".nix" n
        then nameValuePair (removeSuffix ".nix" n) (fn path)
        else nameValuePair "" null)
      (readDir dir);

  # mapModulesRec' :: path -> (path -> a) -> [a]
  #
  # Like mapModulesRec, but returns a flat list of values from all levels.
  mapModulesRec' = dir: fn:
    let
      dirs = mapAttrsToList (k: _: "${dir}/${k}")
        (filterAttrs (n: v: v == "directory" && !(hasPrefix "_" n))
          (readDir dir));
      files = attrValues (mapModules dir id);
      paths = files ++ concatLists (map (d: mapModulesRec' d id) dirs);
    in
    map fn paths;

  # mapHosts :: path -> { darwinConfigurations :: attrs; nixosConfigurations :: attrs; }
  #
  # Discovers host directories, reads each host's system string, and partitions
  # them into darwinConfigurations and nixosConfigurations by calling mkHost.
  # Skips entries prefixed with "_".
  mapHosts = dir:
    let
      mkConfigs = pred:
        mapFilterAttrs (n: v: v != null && !(hasPrefix "_" n))
          (n: v:
            let path = "${toString dir}/${n}"; in
            if v == "directory" &&
               pathExists "${path}/default.nix" &&
               pred (getSystem path)
            then nameValuePair n (mkHost n)
            else nameValuePair "" null)
          (readDir dir);
    in {
      darwinConfigurations = mkConfigs isDarwin;
      nixosConfigurations = mkConfigs (s: !isDarwin s);
    };
}
