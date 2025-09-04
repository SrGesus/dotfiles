#!/usr/bin/env bash

cd $(dirname "$0") &&
# Add files to git or else nix will ignore them
echo "== Adding files to git..." &&
git add . &&

echo "== Building NixOS..." &&
sudo nixos-rebuild switch --flake .#$(hostname) &&

echo "== Committing to git..." &&
git commit -m "NixOS $(date -u --iso-8601=seconds) $(readlink /nix/var/nix/profiles/system | cut -d- -f2) $(hostname) Build" &&

echo "== Pushing to remote..." &&
git push
