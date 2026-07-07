#!/usr/bin/env bash
set -eo pipefail

impure=0

while getopts "i" opt; do
  case $opt in
    i) impure=1 ;;
    *) 
      echo "Usage: nixosbuild [-i]" >&2
      echo "  -i    Run an impure build" >&2
      exit 1 
      ;;
  esac
done

shift $((OPTIND -1))
if [ "$#" -gt 0 ]; then
  echo "Usage: nixosbuild [-i]" >&2
  exit 1
fi

cd /etc/nixos || { echo "Error: Nixos config directory not found."; exit 1; }

#sudo nix fmt &> /dev/null

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git add -A
fi

if [ "$impure" -eq 1 ]; then
  
  export NIXPKGS_ALLOW_UNFREE=1
  export NIXPKGS_ALLOW_INSECURE=1
  export NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1
  sudo nixos-rebuild switch --impure --flake .#"$(hostname)"

else
  sudo nixos-rebuild switch --flake .#"$(hostname)"
fi

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if git diff --cached --quiet; then
    echo "No changes to commit."
    exit 0
  fi
  
  echo ""
  read -rp "Commit message: " message
  
  git commit -m "$message"
  git pull --rebase origin main
  
fi
