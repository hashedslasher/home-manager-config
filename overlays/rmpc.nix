final: prev: {
  rmpc = prev.rmpc.overrideAttrs (old: let
    icon = prev.fetchurl {
      url = "https://rmpc.mierak.dev/favicon.svg";
      sha256 = "sha256-vis28JKOHX87V/Xcuz5ya3B86VtqZXCrqpMi/DdlsJw=";
    };
  in {
    postInstall = (old.postInstall or "") + ''
      mv $out/bin/rmpc $out/bin/rmpc-bin
      
      install -d $out/share/rmpc
      install -d $out/share/applications
      install -d $out/share/icons/hicolor/scalable/apps

      cat > $out/share/rmpc/kitty-rmpc.conf <<EOF
      confirm_os_window_close 0
      EOF

      cat > $out/bin/rmpc <<EOF
      #!${prev.runtimeShell}
      MPD_CONF="\$HOME/.config/rmpc/mpd.conf"
      MPD_SOCKET="/run/user/\$UID/mpd/socket"

      if [ ! -f "\$MPD_CONF" ]; then
        mkdir -p "\$(dirname "\$MPD_CONF")"
        cat > "\$MPD_CONF" <<TEMPLATE
      bind_to_address "\$MPD_SOCKET"
      music_directory "~/Music"
      audio_output {
        type "pipewire"
        name "PipeWire"
      }
      TEMPLATE
      fi

      mkdir -p "\$(dirname "\$MPD_SOCKET")"
      rm -f "\$MPD_SOCKET"

      ${prev.mpd}/bin/mpd --no-daemon "\$MPD_CONF" &
      MPD_PID=\$!

      export MPD_HOST="\$MPD_SOCKET"
      ${prev.mpc}/bin/mpc update

      for i in {1..50}; do [ -S "\$MPD_SOCKET" ] && break; sleep 0.1; done
      
      ${prev.mpd-mpris}/bin/mpd-mpris > /dev/null 2>&1 &
      MPRIS_PID=\$!

      
      trap "kill \$MPD_PID \$MPRIS_PID 2>/dev/null" EXIT

      $out/bin/rmpc-bin "\$@"
      EOF
      chmod +x $out/bin/rmpc

      cat > $out/bin/rmpc-desktop <<EOF
      #!${prev.runtimeShell}
      exec ${prev.kitty}/bin/kitty --class=rmpc --config $out/share/rmpc/kitty-rmpc.conf -e $out/bin/rmpc "\$@"
      EOF
      chmod +x $out/bin/rmpc-desktop

      install -Dm644 ${icon} $out/share/icons/hicolor/scalable/apps/rmpc.svg
      
      rm -f $out/share/applications/rmpc.desktop
      cat > $out/share/applications/rmpc.desktop <<EOF
      [Desktop Entry]
      Name=rmpc
      Exec=$out/bin/rmpc-desktop
      Icon=rmpc
      Type=Application
      Categories=Audio;Music;
      Terminal=false
      EOF
    '';
  });
}
