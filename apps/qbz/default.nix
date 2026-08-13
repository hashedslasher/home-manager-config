{
  config,
  pkgs,
  pkgs-unstable,
  pkgs-stable,
  lib,
  nixpkgs,
  ...
}:
{
  options.apps.qbz = {
    enable = lib.mkEnableOption "qbz config";
  };
  config = lib.mkIf config.apps.nh.enable {
    home.packages = [
      pkgs.qbz
    ];
    xdg.configFile."pipewire/client.conf.d/99-qbz-bitperfect-ii.conf".text = ''
    stream.rules = [
      {
        matches = [
          { application.process.binary = "qbz" }
          { application.name = "PipeWire ALSA [qbz]" }
        ]
        actions = { update-props = { resample.disable = true, channelmix.disable = true } }
      }
    ]
    '';
  };
}

