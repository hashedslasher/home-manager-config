{ config, lib, ... }:
{
  options.apps.wezterm = {
    enable = lib.mkEnableOption "wezterm config";
  };
  config = lib.mkIf config.apps.wezterm.enable {
    xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;
  };
}
