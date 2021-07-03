{ config, pkgs, ... }:

let me = "yevhenshymotiuk";
in {
  users = {
    nix.configureBuildUsers = true;
    users."${me}" = {
      name = me;
      home = "/Users/${me}";
    };
  };

  system.build.applications = pkgs.lib.mkForce (pkgs.buildEnv {
    name = "applications";
    paths = config.environment.systemPackages
      ++ config.home-manager.users."${me}".home.packages;
    pathsToLink = "/Applications";
  });

  system = {
    activationScripts.applications.text = pkgs.lib.mkForce (''
      # disable the creation of desktop sevice store files
      defaults write com.apple.desktopservices DSDontWriteNetworkStores true

      # Copy applications into ~/Applications/Nix. This workaround
      # allows you to find applications installed by nix through spotlight.
      echo "setting up ~/Applications/Nix..."
      hash-app() {
        path="$1/Contents/MacOS"; shift
        for bin in $(find "$path" -perm +111 -type f -maxdepth 1 2>/dev/null); do
          md5sum "$bin" | cut -b-32
        done | md5sum | cut -b-32
      }
      mkdir -p ~/Applications/Nix
      export IFS=$'\n'
      for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
        name="$(basename "$app")"
        src="$(/usr/bin/stat -f%Y "$app")"
        dst="$HOME/Applications/Nix/$name"
        hash1="$(hash-app "$src")"
        hash2="$(hash-app "$dst")"
        if [ "$hash1" != "$hash2" ]; then
          echo "Current hash of '$name' differs than the Nix store's. Overwriting..."
          cp -R "$src" ~/Applications/Nix
          echo "Done"
        fi
      done

      # create password store symlink
      ln -snf ~/Dropbox/.password-store ~/.password-store

      # crate org directory symlink
      mkdir -p ~/dev
      ln -snf ~/Dropbox/org ~/dev/org
    '');
  };

  home-manager = {
    users."${me}" = { pkgs, ... }: { imports = [ ./packages.nix ./programs ]; };
  };
}
