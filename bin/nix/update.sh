set -euo pipefail

NIXOS_DIR="/etc/nixos"
HM_DIR="$HOME/.config/home-manager"

current_host=$(hostname)
stripped_host="${current_host%-*}"
target_host="${stripped_host,,}"

sudo -v

while true; do
  sudo -n true
  sleep 60
done &
KEEPALIVE_PID=$!
trap 'kill $KEEPALIVE_PID' EXIT

sudo nix flake update --flake "$NIXOS_DIR"
nix flake update --flake "$HM_DIR"

sudo nixos-rebuild switch --flake "$NIXOS_DIR"#"$(hostname)"
home-manager switch -b backup --flake "$HM_DIR"#"$target_host"
