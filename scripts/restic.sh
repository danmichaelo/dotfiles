#!/usr/bin/env bash
# Unofficial Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

RESTIC_TARGET_NAME="$1"

. restic-base.sh $RESTIC_TARGET_NAME

restic \
    --repo "${RESTIC_REPOSITORY}" \
    --password-file "${RESTIC_PASSWORD_FILE}" \
    "${@:2}"
