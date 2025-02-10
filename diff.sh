#!/usr/bin/env bash
set -e

OLD=$(git rev-parse "$1")
NEW=$(git rev-parse "$2")

OUT_DIR=$(mktemp -d)
OLD_LINK="$OUT_DIR/old"
NEW_LINK="$OUT_DIR/new"

trap 'rm --force $OLD_LINK $NEW_LINK && rmdir $OUT_DIR' EXIT

toplevel="nixosConfigurations.iridium.config.system.build.toplevel"

nix build "./?rev=$OLD#$toplevel" --out-link "$OLD_LINK" --quiet
nix build "./?rev=$NEW#$toplevel" --out-link "$NEW_LINK" --quiet

nix store diff-closures "$OLD_LINK" "$NEW_LINK"
