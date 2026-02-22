{ config, pkgs, ... }:

with pkgs; {
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
  gtk = {
    enable = true;
    iconTheme = {
      name = "Pop";
      package = pop-icon-theme;
    };
    theme = {
      name = "Pop-dark";
      package = pop-gtk-theme;
    };
    cursorTheme = {
      package = config.home.pointerCursor.package;
      name = config.home.pointerCursor.name;
      size = config.home.pointerCursor.size;
    };
    font = { name = "Fira Code"; size = 8; };
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  home = {
    pointerCursor = {
      gtk.enable = config.gtk.enable;
      package = bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };
    packages = [ dconf ];
  };
}
