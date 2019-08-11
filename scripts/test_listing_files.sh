#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# Unofficial Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'
# ----------------------------------------------------------------------------

# Proper way to list files
# Works with arbitrary filenames including blanks, newlines, and globbing characters
# Source: https://stackoverflow.com/a/54561526/489916
readarray -d '' files < <(find . -type f -mindepth 1 -maxdepth 1 -print0)

printf "Directory contains ${#files[@]} files:\n"

for filename in "${files[@]}"; do
	printf " + $filename\n"
done
