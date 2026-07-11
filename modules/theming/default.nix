{ config, pkgs-unstable, ... }:
{
  home.packages = [
    pkgs-unstable.dracula-theme
    pkgs-unstable.dracula-icon-theme
    pkgs-unstable.arc-theme
    pkgs-unstable.arc-icon-theme
    pkgs-unstable.catppuccin-cursors
    pkgs-unstable.banana-cursor
    pkgs-unstable.bibata-cursors
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
