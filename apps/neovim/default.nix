{ config, lib, pkgs, pkgs-unstable, pkgs-stable, ... }:
{
  imports = [ ../../modules/impermanence ];

  options.apps.neovim = {
    enable = lib.mkEnableOption "neovim config";
    gui.enable = lib.mkEnableOption "Enable Neovide";
  };
  
  config = lib.mkMerge [
    (lib.mkIf config.apps.neovim.enable {
      home.packages = [ pkgs.neovim ];
      
      xdg.configFile."nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/apps/neovim/nvim";
      
      home.persistence.link.dir = [ ".local/share/nvim/lazy" ];
    }) 
    
    (lib.mkIf config.apps.neovim.gui.enable {
        programs.neovide.enable = true;
    }) 
  ];
}
