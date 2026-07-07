{
  description = "RadarOmega AppImage Package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      overlay = final: prev: {
        RadarOmega =
          let
            pname = "RadarOmega";
            version = "5.5.1";

            src = final.fetchurl {
              url = "http://dl.todesktop.com/200402kk4yak2og/linux/appImage/x64";
              hash = "sha256-yPOyu7Vu030cL7gVtNhR4Ag+Bz0H8DiUJXGmFfgouEU=";
            };

            icon = final.fetchurl {
              url = "https://www.radaromega.com/img/favicon.png";
              sha256 = "0dala9n8nbphknipxxr9d3x0v0l98wkd5bx9qyxpr7116y4lcmn7";
            };

            appimageTools = final.appimageTools;
          in
          appimageTools.wrapType2 {
            inherit pname version src;

            extraInstallCommands = ''
              install -m 444 -D ${icon} \
              $out/share/icons/hicolor/256x256/apps/RadarOmega.png

              mkdir -p $out/share/applications

              cat > $out/share/applications/RadarOmega.desktop <<EOF
              [Desktop Entry]
              Name=RadarOmega
              GenericName=Weather Radar
              Exec=RadarOmega
              Icon=RadarOmega
              Type=Application
              Categories=Weather;
              EOF
            '';
          };
      };
    in
    {
      overlays.default = overlay;

      packages = flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ overlay ];
          };
        in
        {
          default = pkgs.RadarOmega;
        }
      );
    };
}
