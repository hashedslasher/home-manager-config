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
    pkgs.guitarix
    pkgs.rufin
    pkgs.audacity
    pkgs.spek
    pkgs.whipper
    pkgs.carla
    pkgs.kid3
    pkgs.gmetronome
  ];

  home.persistence = {
    link = {
      dir = [
      ".config/guitarix"
      ".config/qbz"
      ".config/feedback-desktop"
      ".config/rufin"
      ".local/share/rufin"
      ];
      file = [
        ".cache/mpd/db"
      ];
    };
  };
}
