{
  description = "LTspice(Wine) Package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      overlay =
        final: prev:
        let
          msi = final.fetchurl {
            url = "https://ltspice.analog.com/software/LTspice64.msi";
            sha256 = "sha256-SF2r0tfYKT3nM6OZcZ9lOO/aSlS0ixgaFOBycRhphNM=";
          };

          icon = final.fetchurl {
            url = "https://companieslogo.com/img/orig/LLTC.defunct.2017-444ce5d2.svg";
            sha256 = "sha256-QAS0f7d9mJExH2EW3smuAdn93a+itjUMJS34H00PUCY=";
          };
        in
        {
          ltspice = final.stdenv.mkDerivation {
            pname = "ltspice";
            version = "17";

            nativeBuildInputs = [ final.makeWrapper ];
            dontUnpack = true;

            installPhase = ''
                            mkdir -p $out/bin

                            makeWrapper ${final.wineWowPackages.stable}/bin/wine \
                              $out/bin/ltspice \
                              --set WINEARCH win64 \
                              --set LTSPICE_MSI ${msi} \
                              --run '
                                set -e

                                WINEPREFIX="$HOME/.local/share/ltspice"
                                export WINEPREFIX

                                EXE="$WINEPREFIX/drive_c/Program Files/ADI/LTspice/LTspice.exe"

                                mkdir -p "$WINEPREFIX"

                                if [ ! -x "$EXE" ]; then
                                  echo "LTspice not found in isolated prefix, running installer..."
                                  wine msiexec /i "$LTSPICE_MSI"
                                  sleep 1
                                  rm -rf "$HOME/.local/share/applications/wine/Programs/LTspice"
                                else
                                  exec wine "$EXE"
                                fi
                              '

                            # Install icon
                            mkdir -p $out/share/icons/hicolor/256x256/apps
                            cp ${icon} $out/share/icons/hicolor/256x256/apps/ltspice.svg

                            mkdir -p $out/share/applications
                            cat > $out/share/applications/ltspice.desktop <<EOF
              [Desktop Entry]
              Name=LTspice
              Comment=SPICE Simulator
              Exec=ltspice
              Icon=$out/share/icons/hicolor/256x256/apps/ltspice.svg
              Type=Application
              Categories=Development;Electronics;
              StartupWMClass=LTspice.exe
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
            overlays = [ overlay ];
          };
        in
        {
          default = pkgs.ltspice;
        }
      );
    };
}
