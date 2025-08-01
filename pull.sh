#!/usr/bin/env bash

# usage="
# Usage: rebuild.sh [option]... <subcommand> [nixos-rebuild option]...
# Wrapper for nixos-rebuild that adds changes to git.

# Subcommands:
#   switch
#   boot
#   test
#   build
#   dry-activate

# Options:
#   --push         Perform a git push if successful
#   --flake-update 
# "
# flags=()
# print -P $usage


# if [[ $(git status --porcelain=v1 2>/dev/null | wc -l) > 0 ]]; then
#   # Changes 
#   git add .
#   git commit -m "NixOS $(date -u --iso-8601=seconds) Build"
#   if [[ "$1" == "push" ]]; then
#     git push
#   fi
# fi

cd $(dirname "$0") &&
git pull &&
nixos-rebuild switch --flake .#$(hostname)
