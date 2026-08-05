{
  config,
  lib,
  pkgs-unstable,
  pkgs,
  pkgs-stable,
  ...
}:
{
  imports = [
    ../../bin
    ../../modules/impermanence
    ../../modules/theming
  ];
  
  xdg.configFile."user-dirs.dirs"= {
    text = ''
      XDG_DESKTOP_DIR="$HOME/desktop"
      XDG_DOCUMENTS_DIR="$HOME/documents"
      XDG_DOWNLOAD_DIR="$HOME/downloads"
      XDG_MUSIC_DIR="$HOME/music"
      XDG_PICTURES_DIR="$HOME/pictures"
      XDG_PROJECTS_DIR="$HOME/projects"
      XDG_PUBLICSHARE_DIR="$HOME/public"
      XDG_TEMPLATES_DIR="$HOME/templates"
      XDG_VIDEOS_DIR="$HOME/videos" 
    '';
  };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  programs.autojump.enable = true;

  home.packages = [
    pkgs.libreoffice
    pkgs.thunderbird
    pkgs.bitwarden-desktop
    pkgs.rsync
    pkgs.p7zip
    pkgs.RadarOmega
  ];
  
  home.persistence.link = {
    dir = [
      ".thunderbird"
      
      ".cache/thumbnails"
      
      ".config/Bitwarden"
      ".config/system"
      ".config/RadarOmega"
      
      ".local/share/autojump"
      ".local/state/wireplumber"
      ".local/share/icons"
      ".local/share/applications"
    ];
    file = [
      ".config/mimeapps.list"
    ];
  };
  
  xdg.enable = true;
}
