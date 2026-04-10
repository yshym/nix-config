{ config, pkgs, ... }:

{
  system = {
    primaryUser = config.user.name;
    activationScripts.applications.text = pkgs.lib.mkAfter ''
      # Disable the creation of desktop service store files
      defaults write com.apple.desktopservices DSDontWriteNetworkStores true

      # Create Proton Drive symlink
      ln -snf $HOME/Library/CloudStorage/ProtonDrive-yshym@pm.me-folder $HOME/ProtonDrive

      # Create org directory symlink
      mkdir -p $HOME/dev
      ln -snf $HOME/ProtonDrive/org $HOME/dev/org
    '';
  };

  home = { pkgs, ... }: {
    imports = [ ./packages.nix ./programs ];
    targets.darwin.copyApps = {
      enable = true;
      directory = "Applications/Nix";
    };
  };
}
