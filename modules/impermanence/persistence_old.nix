{
  config,
  lib,
  pkgs,
  ...
}:

let
  username = config.home.username;

  persistRoot = "/persist/home/${username}";
  homeRoot = config.home.homeDirectory;

  state = import ../../profiles/desktop/state.nix;

  linkDirs = state.link.dir or [ ];
  linkFiles = state.link.file or [ ];

  bindDirs = state.bind.dir or [ ];
  bindFiles = state.bind.file or [ ];

  mkPersistPath = path: config.lib.file.mkOutOfStoreSymlink "${persistRoot}/${path}";

  mkHomeFile = path: {
    name = path;
    value.source = mkPersistPath path;
  };

in
{
  home.packages = [ pkgs.bindfs ];

  home.activation.createPersist = lib.hm.dag.entryAfter [ "writeBoundary" ] (

    (lib.concatMapStringsSep "\n" (d: ''
      mkdir -p "${persistRoot}/${d}"
    '') (linkDirs ++ bindDirs))

    +

      (lib.concatMapStringsSep "\n" (f: ''
        mkdir -p "$(dirname "${persistRoot}/${f}")"
        touch "${persistRoot}/${f}"
      '') (linkFiles ++ bindFiles))
  );

  home.activation.bindPersist = lib.hm.dag.entryAfter [ "createPersist" ] (

    (lib.concatMapStringsSep "\n" (d: ''
      homedir="${homeRoot}/${d}"

      if ! ${pkgs.util-linux}/bin/mountpoint -q "$homedir"; then
        if [ -e "$homedir" ]; then
          echo "$homedir in the way. Creating $homedir.backup"
          mv "$homedir" "$homedir.backup"
        fi

        mkdir -p "$homedir"
        ${pkgs.bindfs}/bin/bindfs "${persistRoot}/${d}" "$homedir"
      fi
    '') bindDirs)

    +

      (lib.concatMapStringsSep "\n" (f: ''
        homefile="${homeRoot}/${f}"

        if ! ${pkgs.util-linux}/bin/mountpoint -q "$homefile"; then
          if [ -e "$homefile" ]; then
            echo "$homefile in the way. Creating $homefile.backup"
            mv "$homefile" "$homefile.backup"
          fi

          mkdir -p "$(dirname "$homefile")"
          touch "$homefile"
          
          ${pkgs.bindfs}/bin/bindfs "${persistRoot}/${f}" "$homedir"
        fi
      '') bindFiles)
  );

  home.file = lib.listToAttrs (map mkHomeFile linkDirs ++ map mkHomeFile linkFiles);
}
