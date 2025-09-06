#!/usr/bin/env bash

cd $(dirname "$0") &&
# Add files to git or else nix will ignore them
echo "== Adding files to git..." &&
git add . &&

echo "== Building NixOS..." &&
sudo nixos-rebuild switch --flake .#$(hostname) &&

echo "== Committing to git..." &&

DEFAULT_COMMIT_MSG="NixOS $(date -u --iso-8601=seconds) $(readlink /nix/var/nix/profiles/system | cut -d- -f2) $(hostname) Build"
read -p "Commit message: " PROMPT_COMMIT_MSG
echo $PROMPT_COMMIT_MSG
COMMIT_MSG=$([[ -z "${var// /}" ]] && echo $DEFAULT_COMMIT_MSG || echo $PROMPT_COMMIT_MSG)
echo Commit: $COMMIT_MSG

git commit -m "$COMMIT_MSG" &&

echo "== Pushing to remote..." &&
git push
