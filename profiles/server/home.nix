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

  imports = [
    ../../apps
    ../../modules/impermanence
    ../common
  ];

  home.username = "archon";
  home.homeDirectory = "/home/${config.home.username}";

  programs.home-manager = {
    enable = true;
  };

  apps = {
    git.enable = true;
    neovim.enable = true;
    udiskie.enable = true;
    shell = {
      bash.enable = true;
      zsh.enable = true;
    };
  };

  home.packages = [
  ];
  
  home.persistence = {
    link = {
      dir = [
    ];
    file = [
    ];
    bind.dir = [];
  };

  home.stateVersion = "25.05";
}
