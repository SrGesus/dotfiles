#!/usr/bin/env bash



# Add to tree
echo "== Adding files to git..." &&
git add . &&

# Build and push
echo "== Building NixOS..." &&
sudo nixos-rebuild switch --flake .#$(hostname) &&
echo "== Committing to git..." &&
git commit -m "NixOS $(date -u --iso-8601=seconds) Build" &&
echo "== Pushing to remote..." &&
git push
