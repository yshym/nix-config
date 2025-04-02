{ config, pkgs, ... }:

let me = "yshym";
in
{
  users.users."${me}" = {
    name = me;
    home = "/Users/${me}";
  };

  system = {
    build.applications = pkgs.lib.mkForce (pkgs.buildEnv {
      name = "applications";
      paths = config.environment.systemPackages
        ++ config.home-manager.users."${me}".home.packages;
      pathsToLink = "/Applications";
    });
    activationScripts.applications.text = pkgs.lib.mkForce (
      ''
        # disable the creation of desktop sevice store files
        defaults write com.apple.desktopservices DSDontWriteNetworkStores true

        # Copy applications into ~/Applications/Nix. This workaround
        # allows you to find applications installed by nix through spotlight.
        echo "setting up ~/Applications/Nix..."
        hash-app() {
          path="$1/Contents/MacOS"; shift
          find "$path" -perm +111 -type f -maxdepth 3 2>/dev/null | while read -r bin; do
            md5sum "$bin" | cut -b-32
          done | md5sum | cut -b-32
        }
        export USER="yshym"
        export HOME="/Users/$USER"
        export APPLICATIONS_DIR="$HOME/Applications/Nix"
        mkdir -p "$APPLICATIONS_DIR"
        export IFS=$'\n'
        find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read -r app; do
          name="$(basename "$app")"
          src="$(/usr/bin/stat -f%Y "$app")"
          dst="$APPLICATIONS_DIR/$name"
          if [ -h "$src/Contents/MacOS" ]; then
            src_tmp="/tmp/$name"
            rm -rf "$src_tmp"
            mkdir "$src_tmp"
            cp -r "$src"/* "$src_tmp"
            macos_dir="$src_tmp/Contents/MacOS"
            rm -rf "$macos_dir"
            mkdir -p "$macos_dir"
            cd "$src/Contents"
            cp -r "$(readlink "MacOS")"/* "$macos_dir"
            src="$src_tmp"
          fi
          if [ "$(hash-app "$src")" != "$(hash-app "$dst")" ]; then
            echo "Current hash of '$name' differs from the Nix store's"
            cp -R "$src" "$APPLICATIONS_DIR"
          fi
        done

        # create Proton Drive symlink
        ln -snf $HOME/Library/CloudStorage/ProtonDrive-yshym@pm.me $HOME/ProtonDrive

        # create org directory symlink
        mkdir -p $HOME/dev
        ln -snf $HOME/ProtonDrive/org $HOME/dev/org
      ''
    );
  };

  home-manager = {
    users."${me}" = { pkgs, ... }: { imports = [ ./packages.nix ./programs ]; };
  };
}
