#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# Unofficial Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'
# ----------------------------------------------------------------------------

# Based on bootstrap script by @SlexAxton
# https://github.com/SlexAxton/dotfiles/edit/master/bootstrap.sh

#-----------------------------------------------------------------------------
# Functions
#-----------------------------------------------------------------------------

# Notice title
notice() { printf "\033[1;32m=> $1\033[0m\n"; }

# Error title
error() { printf "\033[1;31m=> Error: $1\033[0m\n"; }

# List item
c_list() { printf  "  \033[1;32m✔\033[0m $1\n"; }

# Error list item
e_list() { printf  "  \033[1;31m✖\033[0m $1\n"; }


ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}

# Check for dependency
dep() {
  type -p $1 &> /dev/null
  local installed=$?
  if [ $installed -eq 0 ]; then
    c_list $1
  else
    e_list $1
  fi
  return $installed
}

# backup() {
#   mkdir -p $backupdir

#   #echo "Exclude: ${excluded[@]}"

#   local files=( $(ls -a) )
#   for file in "${files[@]}"; do
#     in_array $file "${excluded[@]}" || cp -Rf "$HOME/$file" "$backupdir/$file"
#   done
# }

install() {
  # Usage: install {path} {name_pattern}
  find "$1" -mindepth 1 -maxdepth 1 -name "$2" -print0 | while read -d $'\0' filename; do

    # DEBUG: notice "INSTALL ${filename}?"
    if ! in_array $filename "${excluded[@]}"; then

      filename="${filename:2}"
      source_file="${HOME}/.dotfiles/${filename}"
      target_file="${HOME}/${filename}"

      # Check if file exists and is a symbolic link
      if [ -L "${target_file}" ]; then
        rm "${target_file}" 2>/dev/null
      fi

      # Check if file exists and is a regular file
      if [ -f "${target_file}" ]; then
        if [[ "yes" == $(ask_yes_or_no "${target_file} is a regular file. Remove?") ]]; then
            rm -f "${target_file}" 2>/dev/null
        fi
      fi

      # Check if file exists and is a directory
      if [ -d "${target_file}" ]; then
        if [[ "yes" == $(ask_yes_or_no "${target_file} is a directory. Remove?") ]]; then
            rm -rf "${target_file}" 2>/dev/null
        fi
      fi

      # Create symbolic link
      if [ ! -e "${target_file}" ]; then
        c_list "${target_file}"
        ln -s "${source_file}" "${target_file}"
      else
        e_list "${filename}"
      fi
    fi
  done
}

in_array() {
  # Arguments: needle hay1 hay2 hay3...
  local hay needle=$1
  shift
  for hay; do
    [[ "$hay" == "$needle" ]] && return 0
  done
  return 1
}

exclude_non_hidden() {
  # Add non-hidden files and folders to the 'excluded' array unless they are
  # in the 'included' array
  find . -mindepth 1  -maxdepth 1 -not -name ".*" -print0 | while read -d $'\0' filename; do
    in_array $filename "${included[@]}" || excluded+=("$filename")
  done
}


#-----------------------------------------------------------------------------
# Initialize
#-----------------------------------------------------------------------------

backupdir="$HOME/.dotfiles-backup/$(date "+%Y%m%d%H%M.%S")"
dependencies=(git vim xmllint)

# Files/folders not starting with '.' that should still be installed
included=(./scripts)

# Files/folders starting with '.' that should not be installed
excluded=(./.git ./.gitmodules ./.DS_Store ./.config)
exclude_non_hidden

#-----------------------------------------------------------------------------
# Dependencies
#-----------------------------------------------------------------------------

notice "Checking dependencies"

not_met=0
for need in "${dependencies[@]}"; do
  dep $need
  met=$?
  not_met=$(($not_met + $met))
done

if [ $not_met -gt 0 ]; then
  error "$not_met dependencies not met!"
  exit 1
fi


#-----------------------------------------------------------------------------
# Install
#-----------------------------------------------------------------------------

# Debug:
# for nn in "${excluded[@]}"; do
#   notice "exclude: $nn"
# done


# Assumes $HOME/.dotfiles is *ours*
if [ -d $HOME/.dotfiles ]; then
  pushd $HOME/.dotfiles

  # Update Repo
  notice "Updating"
  git pull origin master
  git submodule init
  git submodule update

else
  # Clone Repo
  notice "Downloading"
  git clone --recursive git://github.com/danmichaelo/dotfiles.git $HOME/.dotfiles

  pushd $HOME/.dotfiles

fi

if [ ! -d $HOME/.dotfiles/.vim/bundle/Vundle.vim ]; then

 mkdir -p .vim/bundle
 git clone git://github.com/gmarik/Vundle.vim.git .vim/bundle/Vundle.vim

fi


notice "Linking"
install ./.config "*"
install . "*"

vim +BundleInstall +qall

notice "Configuring mongo-hacker"
pushd $HOME/.dotfiles/mongo-hacker
rm -f $HOME/.mongorc.js
make
popd

#-----------------------------------------------------------------------------
# Finished
#-----------------------------------------------------------------------------

popd
notice "Done"
exec $SHELL -l

