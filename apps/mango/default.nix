{ config, lib, ... }:
{
  options.apps.mango = {
    enable = lib.mkEnableOption "mango config";
  };
  config = lib.mkIf config.apps.mango.enable {
    xdg.configFile."mango".source = ./config;
  };
}
