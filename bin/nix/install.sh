git clone https://gitlab.com/layton10/home-manager "$HOME/.config/home-manager"

nix run home-manager/release-25.05 --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake "$HOME/.config/home-manager"
