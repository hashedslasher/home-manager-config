{
  config,
  pkgs,
  pkgs-unstable,
  pkgs-stable,
  lib,
  nixpkgs,
  ...
}:
{
  imports = [ ../impermanence ];
#  services.mpd = {
#    enable = true;
#    network.startWhenNeeded = true;
#    musicDirectory = "~/Music";
#    extraConfig = ''
#      playlist_directory      "~/Media/mpd/playlists"
#      auto_update "yes"
#
#      audio_output {
#          type "alsa"
#          name "Topping E30 II"
#          device "hw:CARD=II,DEV=0"
#          auto_resample   "no"
#          auto_format     "no"
#          auto_channels   "no"
#          mixer_type      "none"
#      }
#    '';
#  };

  home.packages = [
    pkgs.rmpc
    pkgs.guitarix
    pkgs.qbz
    pkgs.audacity
    pkgs.spek
    pkgs.whipper
    pkgs.carla
    pkgs.kid3
    pkgs.metronome
  ];

  xdg.configFile."rmpc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/modules/music/rmpc";

  home.persistence = {
    link = {
      dir = [
      ".local/share/qbz"
      
      ".config/guitarix"
      ".config/qbz"
      ];
      file = [
        ".cache/mpd/db"
      ];
    };
  };
}
