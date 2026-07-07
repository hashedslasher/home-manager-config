{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.apps.mpv = {
    enable = lib.mkEnableOption "mpv config";
  };
  config = lib.mkIf config.apps.mpv.enable {
    programs.mpv = {
      enable = true;
      config = {
        target-colorspace-hint = false;
        loop-file = "inf";
        no-playlist = true;
      };
    };
  };
}
