#!/usr/bin/env bash

cd $(dirname "$0") &&
# Add files to git or else nix will ignore them
echo "== Adding files to git..." &&
git add . &&

echo "== Building NixOS..." &&
sudo nixos-rebuild switch --flake .#$(hostname) &&

echo "== Committing to git..." &&
DEFAULT_COMMIT_MSG="NixOS $(date -u --iso-8601=seconds) Build $(hostname) $(readlink /nix/var/nix/profiles/system | cut -d- -f2)" &&
read -p "Commit message ($DEFAULT_COMMIT_MSG): " PROMPT_COMMIT_MSG &&
COMMIT_MSG=$([[ -z "${PROMPT_COMMIT_MSG// /}" ]] && echo $DEFAULT_COMMIT_MSG || echo "$PROMPT_COMMIT_MSG\n$DEFAULT_COMMIT_MSG")
git commit -m "$COMMIT_MSG" &&

echo "== Pushing to remote..." &&
git push
