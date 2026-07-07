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
      userName = "layton";
      userEmail = "layton.ab10@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = "/etc/nixos";
      };
    };
  };
}
