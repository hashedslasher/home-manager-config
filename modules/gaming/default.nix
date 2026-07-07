{
  lib,
  config,
  pkgs,
  pkgs-stable,
  ...
}:
{
  imports = [
    ./steam.nix
    ../impermanence
  ];

  home.packages = [
    pkgs.prismlauncher
    #pkgs.rpcs3
    pkgs.retroarch
    pkgs.feedback-desktop
  ];

  programs.mangohud = {
    enable = true;
    settings = {
    };
  };

  xdg.dataFile."PrismLauncher/prismlauncher.cfg".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/modules/gaming/files/prismlauncher.cfg";

  home.persistence = {
    link = {
      dir = [
        ".steam"
        ".local/share/Steam"
        
        ".factorio/config"
        ".factorio/mods"
        
        ".local/share/PrismLauncher/instances"
        ".local/share/PrismLauncher/libraries"
        ".local/share/PrismLauncher/assets"
        
        ".config/retroarch"
        ".config/rpcs3"
        ".config/slopsmith-desktop"
      ];
      file = [
        ".local/share/PrismLauncher/accounts.json"
      ];
    };
  };
}
