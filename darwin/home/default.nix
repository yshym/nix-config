{ config, pkgs, ... }:

let me = "yevhenshymotiuk";
in {
  users = {
    nix.configureBuildUsers = true;
    users.yevhenshymotiuk = {
      name = me;
      home = "/Users/${me}";
    };
  };


  system.build.applications = pkgs.lib.mkForce (pkgs.buildEnv {
    name = "applications";
    paths = config.environment.systemPackages
      ++ config.home-manager.users.yevhenshymotiuk.home.packages;
    pathsToLink = "/Applications";
  });

  system.activationScripts.applications.text = pkgs.lib.mkForce (''
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
  '');

  home-manager = {
    useUserPackages = false;
    users.yevhenshymotiuk = { pkgs, ... }: {
      imports = [ ./packages.nix ./programs ];
    };
  };
}
