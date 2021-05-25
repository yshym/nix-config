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

  system.activationScripts.applications.text = pkgs.lib.mkForce (''
    # disable the creation of desktop sevice store files
    defaults write com.apple.desktopservices DSDontWriteNetworkStores true

    # alias nix applications
    echo "setting up ~/Applications/Nix..."
    rm -rf ~/Applications/Nix
    mkdir -p ~/Applications/Nix
    for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
      src="$(/usr/bin/stat -f%Y "$app")"
      cp -r "$src" ~/Applications/Nix
    done

    # create password store symlink
    ln -snf ~/Dropbox/.password-store ~/.password-store

    # crate org directory symlink
    ln -snf ~/Dropbox/org ~/dev/org
  '');

  home-manager = {
    users."${me}" = { pkgs, ... }: {
      imports = [ ./packages.nix ./programs ];
    };
  };
}
