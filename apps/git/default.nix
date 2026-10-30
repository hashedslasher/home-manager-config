{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  nixpkgs,
  ...
}:
{
  options.apps.git = {
    enable = lib.mkEnableOption "Git config";
  };
  config = lib.mkIf config.apps.git.enable {
    programs.git = {
      enable = true;
      settings = {
        user.name = "layton";
        user.email = "layton.ab10@gmail.com";
        init.defaultBranch = "main";
        safe.directory = "/etc/nixos";
      };
    };
  };
}
