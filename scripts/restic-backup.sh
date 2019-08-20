#!/usr/bin/env bash
# Unofficial Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

## Config ---------------------------------------------------------------------

RESTIC_SOURCE="${HOME}"
RESTIC_TARGET_NAME="${1:-}"
RESTIC_EXCLUDE_FILE="${HOME}/.config/restic/excludes"
RESTIC_PASSWORD_FILE="${HOME}/.config/restic/repo-passwords/${RESTIC_TARGET_NAME}"

# Load environment file if it exists
source "${HOME}/.config/restic/env/${RESTIC_TARGET_NAME}" 2>/dev/null || true

## Repository -----------------------------------------------------------------

case $RESTIC_TARGET_NAME in
    red)
        RESTIC_TARGET_DISPLAY_NAME="WD Red"
        RESTIC_REPOSITORY="/Volumes/Backup2019/restic-backup"
        ;;
    syn)
        RESTIC_TARGET_DISPLAY_NAME="Synology"
        RESTIC_REPOSITORY="rest:http://${RESTIC_REST_USER}:${RESTIC_REST_PASSWORD}@${RESTIC_REST_HOST}:${RESTIC_REST_PORT}/"
        ;;
    *)
        echo "Unknown backup target $RESTIC_TARGET_NAME"
        exit 1
esac

## Check if the backup repository can be reached ------------------------------

# @see: https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
if [ ! -z "${RESTIC_REST_HOST:-}" ]; then
    if ! ping -W 1 -c 1 ${RESTIC_REST_HOST} > /dev/null ; then
        printf "Restic rest repository host is not available\n"
        /usr/local/bin/terminal-notifier -title "Restic" \
            -message "Skipping backup to ${RESTIC_TARGET_DISPLAY_NAME} since it's not available"
        false
    fi
else
    if [ ! -d "${RESTIC_REPOSITORY}" ]; then
        printf "Restic rest repository volume is not available\n"
        /usr/local/bin/terminal-notifier -title "Restic" \
            -message "Skipping backup to ${RESTIC_REPOSITORY} since it's not available"
        false
    fi
fi

## Run a backup ---------------------------------------------------------------

/usr/local/bin/terminal-notifier -title "Restic" \
    -message "Starting backup to ${RESTIC_TARGET_DISPLAY_NAME}"

printf "\n[$(date '+%F %T')] Starting backup ------------------------------------------------\n"

/usr/local/bin/cpulimit -l 100 /usr/local/bin/restic backup \
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
