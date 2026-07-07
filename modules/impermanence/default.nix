{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.home.persistence;
  persistRoot = "/persist/home/${config.home.username}";
  homeRoot = config.home.homeDirectory;

  allLinks = cfg.link.dir ++ cfg.link.file;
  allBinds = cfg.bind.dir ++ cfg.bind.file;

in {
  options.home.persistence = {
    link = {
      dir = mkOption { type = types.listOf types.str; default = []; };
      file = mkOption { type = types.listOf types.str; default = []; };
    };
    bind = {
      dir = mkOption { type = types.listOf types.str; default = []; };
      file = mkOption { type = types.listOf types.str; default = []; };
    };
  };

  config = mkIf (cfg.link != {} || cfg.bind != {}) {
    home.packages = [ pkgs.bindfs ];

    home.activation.createPersist = hm.dag.entryAfter [ "writeBoundary" ] (
      (concatMapStringsSep "\n" (d: ''
        mkdir -p "${persistRoot}/${d}"
      '') (cfg.link.dir ++ cfg.bind.dir))
      +
      (concatMapStringsSep "\n" (f: ''
        mkdir -p "$(dirname "${persistRoot}/${f}")"
        touch "${persistRoot}/${f}"
      '') (cfg.link.file ++ cfg.bind.file))
    );

    home.activation.bindPersist = hm.dag.entryAfter [ "createPersist" ] (
      (concatMapStringsSep "\n" (d: ''
        homedir="${homeRoot}/${d}"
        if ! ${pkgs.util-linux}/bin/mountpoint -q "$homedir"; then
          if [ -e "$homedir" ]; then
            echo "$homedir in the way. Creating $homedir.backup"
            mv "$homedir" "$homedir.backup"
          fi
          mkdir -p "$homedir"
          ${pkgs.bindfs}/bin/bindfs "${persistRoot}/${d}" "$homedir"
        fi
      '') cfg.bind.dir)
      +
      (concatMapStringsSep "\n" (f: ''
        homefile="${homeRoot}/${f}"
        if ! ${pkgs.util-linux}/bin/mountpoint -q "$homefile"; then
          if [ -e "$homefile" ]; then
            echo "$homefile in the way. Creating $homefile.backup"
            mv "$homefile" "$homefile.backup"
          fi
          mkdir -p "$(dirname "$homefile")"
          touch "$homefile"
          ${pkgs.bindfs}/bin/bindfs "${persistRoot}/${f}" "$homefile"
        fi
      '') cfg.bind.file)
    );

    home.file = listToAttrs (map (path: {
      name = path;
      value.source = config.lib.file.mkOutOfStoreSymlink "${persistRoot}/${path}";
    }) allLinks);
  };
}
