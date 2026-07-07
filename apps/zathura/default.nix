{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.apps.zathura = {
    enable = lib.mkEnableOption "zathura config";
  };
  config = lib.mkIf config.apps.zathura.enable {
    programs.zathura = {
      enable = true;
      options = {
        enable = true;
        adjust_window = "best-fit";
        guioptions = "sv";

      };
    };
  };
}
