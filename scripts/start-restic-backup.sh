#!/usr/bin/env bash
# Unofficial Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

## General backup script ------------------------------------------------------

RESTIC_EXCLUDE_FILE="${HOME}/.config/restic/excludes"
RESTIC_LOG_FILE="${HOME}/log/restic-${RESTIC_TARGET_NAME}.log"
RESTIC_PASSWORD_FILE="${HOME}/.config/restic/repo-passwords/${RESTIC_TARGET_NAME}"

terminal-notifier -title "Restic" -message "Starting backup to ${RESTIC_TARGET_DISPLAY_NAME}"

printf "\n[$(date '+%F %T')] Starting backup ------------------------------------------------" >> "${RESTIC_LOG_FILE}"

restic backup \
       --repo "${RESTIC_REPOSITORY}" \
       --password-file "${RESTIC_PASSWORD_FILE}" \
       --exclude-file="${RESTIC_EXCLUDE_FILE}" \
       "${RESTIC_SOURCE}" >> "${RESTIC_LOG_FILE}" 2>&1

terminal-notifier -title "Restic" -message "Backup complete to ${RESTIC_TARGET_DISPLAY_NAME}"
