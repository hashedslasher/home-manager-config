{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.homelinks;

  pathToMountUnit =
    path:
    let
      stripped = removePrefix "/" path;
      replaced = replaceStrings [ "/" "-" ] [ "-" "\\x2d" ] stripped;
    in
    "${replaced}.mount";

  mountUnit = pathToMountUnit cfg.drive;

  linkManager = pkgs.writeShellScript "external-home-links" ''
    DRIVE="${cfg.drive}"

    if ${pkgs.util-linux}/bin/mountpoint -q "$DRIVE"; then
      ${concatMapStringsSep "\n" (d: ''
        ${pkgs.coreutils}/bin/ln -sfn "$DRIVE/${d}" "$HOME/${d}"
        echo linking ${d}
      '') cfg.dirs}
    else
      ${concatMapStringsSep "\n" (d: ''
        if [ -L "$HOME/${d}" ]; then
          rm "$HOME/${d}"
        fi
      '') cfg.dirs}
    fi
  '';

in
{
  options.homelinks = {
    enable = mkEnableOption "External drive home directory symlinks";

    drive = mkOption {
      type = types.str;
      example = "/mnt/external-hdd";
      description = "Mount point of the external drive.";
    };

    dirs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "Documents"
        "Pictures"
        "Videos"
      ];
      description = "Home directories that should link to the external drive.";
    };
  };

  config = mkIf cfg.enable {

    systemd.user.services.external-homelinks = {
      Unit = {
        Description = "Manage home directory symlinks for external drive";
        BindsTo = [ mountUnit ];
        After = [ mountUnit ];
      };

      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = linkManager;
        ExecStop = linkManager;
      };

      Install = {
        WantedBy = [
          "default.target"
          mountUnit
        ];
      };
    };

  };
}
