#!/usr/bin/env bash

nix flake update --commit-lock-file
./diff.sh HEAD^ HEAD
