{
  description = "feedBack Desktop Nix Flake (AppImage)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      feedbackOverlay = final: prev: {
        feedback-desktop =
          let
            pname = "feedback-desktop";
            version = "0.3.0-alpha.1";

            src = final.fetchurl {
              url = "https://github.com/got-feedBack/feedBack-desktop/releases/download/v${version}/feedback-0.3.0-x86_64.AppImage";
              sha256 = "beaf08a9513ab97afb4943277406f1584b86c6ad4f5a702c1646712a600d5f83";
            };

            appimageContents = final.appimageTools.extractType2 {
              inherit pname version src;
            };

            desktopItem = final.makeDesktopItem {
              name = pname;
              exec = pname;
              icon = "feedBack";
              comment = "Native wrapper for feedBack CDLC browser";
              desktopName = "feedBack Desktop";
              categories = [ "AudioVideo" "Audio" ];
            };
          in
          final.appimageTools.wrapType2 {
            inherit pname version src;

            extraInstallCommands = ''
              mkdir -p $out/share/applications
              cp ${desktopItem}/share/applications/* $out/share/applications/

              if [ -d "${appimageContents}/usr/share/icons" ]; then
                cp -r ${appimageContents}/usr/share/icons/* $out/share/icons/
              else
                mkdir -p $out/share/icons/hicolor/scalable/apps/
                cp ${appimageContents}/.DirIcon $out/share/icons/hicolor/scalable/apps/feedback.png
              fi
            '';

            meta = with final.lib; {
              description = "Native wrapper for feedBack CDLC browser";
              homepage = "https://github.com/got-feedBack/feedBack-desktop";
              license = licenses.mit;
              platforms = [ "x86_64-linux" ];
              mainProgram = pname;
            };
          };
      };
    in
    {
      overlays.default = feedbackOverlay;
    } 
    // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ feedbackOverlay ];
        };
      in
      {
        packages.default = pkgs.feedback-desktop;

        devShells.default = pkgs.mkShell {
          packages = [ pkgs.feedback-desktop ];
        };
      }
    );
}
