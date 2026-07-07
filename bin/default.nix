{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "nixosbuild";
      text = builtins.readFile ./nix/nixosbuild.sh;
    })

    (pkgs.writeShellApplication {
      name = "homebuild";
      text = builtins.readFile ./nix/homebuild.sh;
    })

    (pkgs.writeShellApplication {
      name = "update";
      text = builtins.readFile ./nix/update.sh;
    })

    (pkgs.writeShellApplication {
      name = "homeclean";
      text = builtins.readFile ./nix/homeclean.sh;
    })

    (pkgs.writeShellApplication {
      name = "playerhelper";
      text = builtins.readFile ./sys/playerhelper.sh;
    })

    (pkgs.writeShellApplication {
      name = "hconvert";
      runtimeInputs = [ pkgs.imagemagick ];
      text = builtins.readFile ./sys/convertfiles.sh;
    })
  ];
}
