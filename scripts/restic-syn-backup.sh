#!/usr/bin/env bash
# Unofficial Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'
set -a

## General settings -----------------------------------------------------------

RESTIC_SOURCE="${HOME}"
RESTIC_TARGET_NAME="syn"
RESTIC_TARGET_DISPLAY_NAME="Synology"

## Source environment file if it exists ---------------------------------------

source "${HOME}/.config/restic/env/${RESTIC_TARGET_NAME}" 2>/dev/null || true

## Repository setup -----------------------------------------------------------

RESTIC_REPOSITORY="rest:http://${RESTIC_REST_USER}:${RESTIC_REST_PASSWORD}@${RESTIC_REST_HOST}:${RESTIC_REST_PORT}/"

## General backup script ------------------------------------------------------

${BASH_SOURCE%/*}/start-restic-backup.sh
