#!/usr/bin/env bash

set -e
for f in $(pwd)/.devcontainer/post-create-scripts/*.sh; do
  bash "$f"
done
