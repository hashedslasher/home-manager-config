{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
{
  programs.steam.config = {
    enable = true;
    onSteamRunning = "force-close";
    apps = {
      mx-bikes = {
        id = 655500;
        launchOptions = {
          wrappers = [
            "PROTON_ENABLE_WAYLAND=1"
          ];
          preHook = ''
            rm -rf ~/.steam/steam/steamapps/compatdata/655500/pfx/drive_c/users/steamuser/Documents/PiBoSo/'MX Bikes'/mods

            ln -sfn ~/app-data/'MX Bikes'/mods ~/.steam/steam/steamapps/compatdata/655500/pfx/drive_c/users/steamuser/Documents/PiBoSo/'MX Bikes'/mods


            rm -rf ~/.steam/steam/steamapps/compatdata/655500/pfx/drive_c/users/steamuser/Documents/PiBoSo/'MX Bikes'/profiles

            ln -sfn ~/app-data/'MX Bikes'/profiles ~/.steam/steam/steamapps/compatdata/655500/pfx/drive_c/users/steamuser/Documents/PiBoSo/'MX Bikes'/profiles
          '';
        };
      };
    };
    nonSteamApps = {
      MW3 = {
        name = "Call of Duty: Modern Warfare® 3 - PS3";
        target = "${pkgs.bash}/bin/bash";
        #icon = "/mnt/external-hdd/Games/ROMs/PS3/Call\ of\ Duty\ -\ Modern\ Warfare\ 3\ \(USA\)/PS3_GAME/ICON0.png";
        #launchOptionsStr = "${pkgs-stable.rpcs3}/bin/rpcs3 --no-gui '/mnt/external-hdd/Games/ROMs/PS3/Call\ of\ Duty\ -\ Modern\ Warfare\ 3\ \(USA\)/PS3_GAME/USRDIR/EBOOT.BIN'";
      };
      Horizon-Zero-Dawn = {
        name = "Horizon Zero Dawn™ Remastered";
        target = "/home/layton/.steam/steam/steamapps/common/Horizon-Zero-Dawn-Re-SteamRIP.com/Horizon\ Zero\ Dawn\ Remastered/HorizonZeroDawnRemastered.exe";
        seed = "horizon-zero-dawn";
        compatTool = "proton_experimental";
        #icon = "/mnt/external-hdd/Games/PC/Horizon-Zero-Dawn-Re-SteamRIP.com/Horizon Zero Dawn Remastered/Horizon-Zero-Dawn-Remastered.png";
        launchOptions = {
          preHook = ''
            SRC="/mnt/external-hdd/Games/PC/Horizon-Zero-Dawn-Re-SteamRIP.com"
            DEST="~/.steam/steam/steamapps/common"
            nix shell nixpkgs#alacritty nixpkgs#rsync nixpkgs#pv -c bash -c "
              alacritty -e bash -c '
                rsync -a --info=progress2 "$SRC" "$DEST"
              '
            "
            rm -rf ~/.steam/steam/steamapps/compatdata/4275968438
            ln -sfn /mnt/external-hdd/Games/GameState/Prefix/4275968438 ~/.steam/steam/steamapps/compatdata/4275968438
          '';
        };
      };
    };
  };
}
