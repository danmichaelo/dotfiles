#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# Unofficial Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'
# ----------------------------------------------------------------------------

# Usage: openssl_get_site_certificate.sh {domain}

openssl s_client -connect "$1":443 -servername "$1" -showcerts </dev/null 2>/dev/null | openssl x509 -outform PEM
