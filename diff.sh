#!/usr/bin/env bash

OLD=$(git rev-parse $1)
NEW=$(git rev-parse $2)

nix build "git+file:///home/jess/dotfiles?rev=$OLD#nixosConfigurations.nixos.config.system.build.toplevel" --out-link old --quiet
nix build "git+file:///home/jess/dotfiles?rev=$NEW#nixosConfigurations.nixos.config.system.build.toplevel" --out-link new --quiet

nix store diff-closures ./old ./new && rm old new
