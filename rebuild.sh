#!/usr/bin/env bash

cd $(dirname "$0") &&
# Add files to git or else nix will ignore them
printf "== Adding files to git...\n" &&
git add . &&

printf "== Building NixOS...\n" &&
sudo nixos-rebuild switch --flake .#$(hostname) &&

printf "== Committing to git...\n" &&
DEFAULT_COMMIT_MSG="NixOS $(date -u --iso-8601=seconds) Build $(hostname) $(readlink /nix/var/nix/profiles/system | cut -d- -f2)" &&
read -p "Commit message ($DEFAULT_COMMIT_MSG): " PROMPT_COMMIT_MSG &&
COMMIT_MSG=$([[ -z "${PROMPT_COMMIT_MSG// /}" ]] && printf $DEFAULT_COMMIT_MSG || printf "$PROMPT_COMMIT_MSG\n$DEFAULT_COMMIT_MSG")
git commit -m "$COMMIT_MSG" &&

printf "== Pushing to remote...\n" &&
git push
