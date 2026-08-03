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
  options.apps.nh = {
    enable = lib.mkEnableOption "nh";
  };
  config = lib.mkIf config.apps.nh.enable {
    programs.nh = {
      enable = true;
      osFlake = "/etc/nixos";
      homeFlake = "${config.xdg.configHome}/home-manager";
    };
  };
}
