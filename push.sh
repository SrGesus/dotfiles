#!/usr/bin/env bash

# Build and push
nixos-rebuild switch --flake .#$(hostname)

git add .
git commit -m "NixOS $(date -u --iso-8601=seconds) Build"
git push
