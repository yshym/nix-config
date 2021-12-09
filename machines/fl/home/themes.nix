{ pkgs, ... }:

with pkgs; {
  gtk = {
    enable = true;
    iconTheme = {
      name = "Pop-dark";
      package = pop-icon-theme;
    };
    theme = {
      name = "Pop";
      package = pop-gtk-theme;
    };
    gtk3.extraConfig.gtk-cursor-theme-name = "Bibata_Oil";
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  home.packages = [ dconf bibata-cursors ];
}
