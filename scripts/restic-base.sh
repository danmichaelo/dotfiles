#!/usr/bin/env bash
# Unofficial Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

## Config ---------------------------------------------------------------------

RESTIC_SOURCE="${HOME}"
RESTIC_TARGET_NAME="$1"
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
        echo "Unknown Restic target: $RESTIC_TARGET_NAME"
        exit 1
esac

## Check if the backup repository can be reached ------------------------------

# @see: https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
if [ ! -z "${RESTIC_REST_HOST:-}" ]; then
    if ! ping -W 1 -c 1 ${RESTIC_REST_HOST} > /dev/null ; then
        printf "Restic rest repository host is not available\n"
        /usr/local/bin/terminal-notifier -title "Restic" \
            -message "Skipping unvailable Restic target: ${RESTIC_TARGET_DISPLAY_NAME}"
        false
    fi
else
    if [ ! -d "${RESTIC_REPOSITORY}" ]; then
        printf "Restic rest repository volume is not available\n"
        /usr/local/bin/terminal-notifier -title "Restic" \
            -message "Skipping unvailable Restic target: ${RESTIC_REPOSITORY}"
        false
    fi
fi
