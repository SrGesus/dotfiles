#!/usr/bin/env bash

cd $(dirname "$0") &&
# Add files to git or else nix will ignore them
printf "== Adding files to git...\n" &&
git add . &&

printf "== Building NixOS...\n" &&
sudo nixos-rebuild test --flake .#$(hostname) &&

