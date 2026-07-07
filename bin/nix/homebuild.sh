#!/usr/bin/env bash
set -eo pipefail

impure=0

while getopts "i" opt; do
  case $opt in
    i) impure=1 ;;
    *) 
      echo "Usage: homebuild [-i]" >&2
      echo "  -i    Run an impure build" >&2
      exit 1 
      ;;
  esac
done

shift $((OPTIND -1))
if [ "$#" -gt 0 ]; then
  echo "Usage: homebuild [-i]" >&2
  exit 1
fi

cd "$HOME/.config/home-manager" || { echo "Error: Home Manager directory not found."; exit 1; }

#nix fmt &> /dev/null

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git add -A
fi

current_host=$(hostname)
stripped_host="${current_host%-*}"
target_host="${stripped_host,,}"

if [ "$impure" -eq 1 ]; then
  
  export NIXPKGS_ALLOW_UNFREE=1
  export NIXPKGS_ALLOW_INSECURE=1
  export NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1

  home-manager switch -b backup --impure --flake .#"${target_host}"
else
  home-manager switch -b backup --flake .#"${target_host}"
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
