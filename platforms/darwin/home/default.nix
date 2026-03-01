{ config, pkgs, ... }:

let
  applicationsEnv = pkgs.buildEnv {
    name = "applications";
    paths = config.environment.systemPackages
      ++ config.user.packages
      ++ config.home.home.packages;
    pathsToLink = [ "/Applications" ];
  };
in
{
  system = {
    primaryUser = config.user.name;
    activationScripts.applications.text = pkgs.lib.mkAfter ''
      # Disable the creation of desktop service store files
      defaults write com.apple.desktopservices DSDontWriteNetworkStores true

      # Alias applications into ~/Applications/Nix using mkalias
      echo "setting up ~/Applications/Nix..."
      export USER="yshym"
      export HOME="/Users/$USER"
      export APPLICATIONS_DIR="$HOME/Applications/Nix"
      rm -rf "$APPLICATIONS_DIR"
      mkdir -p "$APPLICATIONS_DIR"
      find ${applicationsEnv}/Applications -maxdepth 1 -type l | while read -r app; do
        name="$(basename "$app")"
        src="$(/usr/bin/stat -f%Y "$app")"
        echo "aliasing $name" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "$APPLICATIONS_DIR/$name"
      done

      # Create Proton Drive symlink
      ln -snf $HOME/Library/CloudStorage/ProtonDrive-yshym@pm.me $HOME/ProtonDrive

      # Create org directory symlink
      mkdir -p $HOME/dev
      ln -snf $HOME/ProtonDrive/org $HOME/dev/org
    '';
  };

  home = { pkgs, ... }: { imports = [ ./packages.nix ./programs ]; };
}
