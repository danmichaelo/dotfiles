#!/usr/bin/env bash
# Unofficial Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

RESTIC_TARGET_NAME="$1"

. restic-base.sh $RESTIC_TARGET_NAME

/usr/local/bin/terminal-notifier -title "Restic" \
    -message "Starting backup to ${RESTIC_TARGET_DISPLAY_NAME}"

printf "\n[$(date '+%F %T')] Starting backup ------------------------------------------------\n"

/usr/local/bin/cpulimit -l 100 restic.sh $1 backup --cleanup-cache "${RESTIC_SOURCE}" \
    --repo "${RESTIC_REPOSITORY}" \
    --password-file "${RESTIC_PASSWORD_FILE}" \
    --exclude-file="${RESTIC_EXCLUDE_FILE}" \
    --cleanup-cache \
    "${RESTIC_SOURCE}"

/usr/local/bin/restic forget \
    --repo "${RESTIC_REPOSITORY}" \
    --password-file "${RESTIC_PASSWORD_FILE}" \
    --group-by paths,tags \
    --keep-last 12 --keep-daily 7 --keep-weekly 52 --keep-yearly 10

/usr/local/bin/terminal-notifier -title "Restic" \
    -message "Backup complete to ${RESTIC_TARGET_DISPLAY_NAME}"
