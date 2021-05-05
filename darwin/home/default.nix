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
    chown ${me} ~/Applications/Nix
    find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read f; do
      src="$(/usr/bin/stat -f%Y $f)"
      appname="$(basename $src)"
      osascript -e "tell app \"Finder\" to make alias file at POSIX file \"/Users/${me}/Applications/Nix/\" to POSIX file \"$src\" with properties {name: \"$appname\"}";
    done

    # create icloud drive symlink
    ln -snf ~/Library/Mobile\ Documents/com\~apple\~CloudDocs ~/icloud

    # create password store symlink
    ln -snf ~/icloud/.password-store ~/.password-store

    # crate org directory symlink
    ln -snf ~/Library/Mobile\ Documents/iCloud\~com\~appsonthemove\~beorg/Documents/org ~/dev/org
  '');

  home-manager = {
    useUserPackages = false;
    users."${me}" = { pkgs, ... }: {
      imports = [ ./packages.nix ./programs ];
    };
  };
}
