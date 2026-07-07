{ pkgs ? import <nixpkgs> {} }:

let
  pythonStartup = pkgs.writeText "py-calculator.py" ''
    import math
    import sympy as sp
    print("sympy imported as sp")
  '';
in
pkgs.mkShell {
  packages = with pkgs; [
    alacritty
    (pkgs.python3.withPackages (ps: with ps; [ sympy ]))
  ];
  shellHook = ''
    export PYTHONSTARTUP=${pythonStartup}
    alacritty -o window.opacity=0.7 -o font.size=14 --class py-calculator -e python -q
    exit
  '';
}
