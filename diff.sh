#!/usr/bin/env bash
set -e

OLD=$(git rev-parse "$1")
NEW=$(git rev-parse "$2")

OUT_DIR=$(mktemp -d)
OLD_LINK="$OUT_DIR/old"
NEW_LINK="$OUT_DIR/new"

trap 'rm --force $OLD_LINK $NEW_LINK && rmdir $OUT_DIR' EXIT

toplevel="nixosConfigurations.iridium.config.system.build.toplevel"

nix build --log-format multiline "./?rev=$OLD#$toplevel" --out-link "$OLD_LINK" --quiet
nix build --log-format multiline "./?rev=$NEW#$toplevel" --out-link "$NEW_LINK" --quiet

nix store diff-closures "$OLD_LINK" "$NEW_LINK"

if [ "$3" == "verbose" ]; then
    nix-diff --skip-already-compared --character-oriented "$OLD_LINK" "$NEW_LINK"
fi
