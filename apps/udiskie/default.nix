{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  nixpkgs,
  ...
}:
{
  options.apps.udiskie = {
    enable = lib.mkEnableOption "udiskie config";
  };
  config = lib.mkIf config.apps.udiskie.enable {
    services.udiskie = {
      enable = true;
      settings = {
        program_options = {
          file_manager = "/run/current-system/sw/bin/thunar";
        };
      };
    };
  };
}
