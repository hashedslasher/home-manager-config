final: prev: {
  retroarch = final.symlinkJoin {
    name = "retroarch-sync";
    
    paths = [
      (final.writeShellApplication {
        name = "retroarch";
        
        runtimeInputs = [ 
          prev.retroarch 
          final.rclone 
          final.coreutils 
        ];

        text = ''
          LOCAL_DIR="$HOME/.config/retroarch"
          REMOTE_DIR="myremote:retroarch_backup"

          mkdir -p "$LOCAL_DIR"

          rclone sync "$REMOTE_DIR" "$LOCAL_DIR" || echo "⚠️ Pre-sync failed!"

          set +e
          ${prev.retroarch}/bin/retroarch "$@"
          RETROARCH_EXIT_CODE=$?
          set -e

          rclone sync "$LOCAL_DIR" "$REMOTE_DIR" || echo "⚠️ Post-sync failed!"

          exit $RETROARCH_EXIT_CODE
        '';
      })

      prev.retroarch
    ];
  };
}
