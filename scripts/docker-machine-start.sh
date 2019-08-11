#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# Unofficial Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'
# ----------------------------------------------------------------------------

# Remove Docker machine environment variables from .bashrc.local

BASHRC=./.bashrc.local

# in-place sed that works with BSD and GNU sed:


sed -i.bak "/DOCKER_/d" "${BASHRC}"
rm "${BASHRC}.bak"

# Make sure Docker machine is running
docker-machine start || true

# Add Docker machine environment variables to .bashrc.local
docker-machine env default | grep "DOCKER_" >> "${BASHRC}"
