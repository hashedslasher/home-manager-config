{
  config,
  pkgs,
  pkgs-unstable,
  pkgs-stable,
  lib,
  nixpkgs,
  inputs,
  ...
}:

{

  # imports = [ (import ./import-tree ./modules) ];
  imports = [
    ../../apps
    #../../modules/gaming
    #../../modules/homelinks
    #../../modules/music
    ../../modules/impermanence
    ../common
  ];

  home.username = "layton";
  home.homeDirectory = "/home/${config.home.username}";

  programs.home-manager = {
    enable = true;
  };

  #homelinks = {
  #  enable = false;

  #  drive = "/mnt/tsb-2tb";

  #  dirs = [
  #    "app-data"
  #    "apps"
  #    "documents"
  #    "media"
  #    "music"
  #    "pictures"
  #    "projects"
  #    "school"
  #    "scripts"
  #    "videos"
  #    "notes"
  #    "cad"
  #  ];
  #};

  apps = {
    btop.enable = true;
    git.enable = true;
    mango.enable = true;
    mpv.enable = true;
    neovim = {
      enable = true;
      gui.enable = true;
    };
    nh.enable = true;
    udiskie.enable = true;
    wezterm.enable = true;
    zathura.enable = true;
    shell = {
      bash.enable = true;
      zsh.enable = true;
    };
  };

  home.packages = [
    #Apps
    pkgs.discord
    pkgs-stable.supercell-wx

    pkgs.freetube
    pkgs.foliate
    pkgs-unstable.zennotes-desktop
    #Utils
    pkgs.fastfetch
    pkgs.wineWow64Packages.base
    pkgs.winetricks
    pkgs.nwg-look
  ];

  home.persistence = {
    link = {
      dir = [
      
      "downloads"
      "persistent"

      ".ssh"
      #move to nixos
      ".kodi"
      ".local/share/ltspice"
      ".local/share/Supercell Wx"
      ".local/share/com.github.johnfactotum.Foliate"
      ".local/share/matlab"


      ".config/Mullvad VPN"
      ".config/xfce4/xfconf/xfce-perchannel-xml"
      ".config/BraveSoftware/Brave-Origin-Nightly"
      ".config/dconf"
      ".config/xournalpp"

      ".cache/com.github.johnfactotum.Foliate"
      
      ];
      file = [
      ];
    };
    bind.dir = [];
  };
  home.stateVersion = "26.05";
}

