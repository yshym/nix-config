{ pkgs, ... }:

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
      package = bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };
    font = { name = "Fira Code"; size = 8; };
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
  home.packages = [ dconf ];
}
