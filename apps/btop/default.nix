{ config, lib, pkgs, pkgs-unstable, pkgs-stable, ... }: 

let
  cfg = config.apps.btop;

  btopIcon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/aristocratos/btop/main/Img/icon.svg";
    hash = "sha256-/diL8XzwQtlqeGQn0awr8WQVEPNK7lfoBQigp4HCQl0=";
  };
in
{
  options.apps.btop = {
    enable = lib.mkEnableOption "enable btop and a btop desktop launcher";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.btop ];
    xdg.desktopEntries.btop = {
      name = "btop";
      exec = "${pkgs.alacritty}/bin/alacritty --class btop --title btop -e ${pkgs.btop}/bin/btop";
      icon = "${btopIcon}"; 
      terminal = false;
      categories = [ "Utility" ];
    };
  };
}
