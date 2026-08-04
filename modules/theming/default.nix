{ config, pkgs-unstable, pkgs-stable, ... }:
{
  home.packages = [
    pkgs-unstable.catppuccin-cursors
    pkgs-unstable.bibata-cursors
    pkgs-stable.gruvbox-material-gtk-theme
  ];

  home.persistence = {
    link = {
      dir = [
        ".config/gtk-3.0"
        ".config/gtk-4.0"
        ".themes"
        ".icons"
      ];
      file = [
        ".gtkrc-2.0"
        ".config/xsettingsd/xsettingsd.conf"
      ];
    };
  };
}
