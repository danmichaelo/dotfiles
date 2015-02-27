#!/bin/bash
# Based on bootstrap script by @SlexAxton
# https://github.com/SlexAxton/dotfiles/edit/master/bootstrap.sh

#-----------------------------------------------------------------------------
# Functions
#-----------------------------------------------------------------------------

echo="echo -e"

# Notice title
notice() { $echo "\033[1;32m=> $1\033[0m"; }

# Error title
error() { $echo "\033[1;31m=> Error: $1\033[0m"; }

# List item
c_list() { $echo  "  \033[1;32m✔\033[0m $1"; }

# Error list item
e_list() { $echo  "  \033[1;31m✖\033[0m $1"; }


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

backup() {
  mkdir -p $backupdir

  #echo "Exclude: ${excluded[@]}"

  local files=( $(ls -a) )
  for file in "${files[@]}"; do
    in_array $file "${excluded[@]}" || cp -Rf "$HOME/$file" "$backupdir/$file"
  done
}

install() {
  local files=( $(ls -a | grep '^\..*') )
  for file in "${files[@]}"; do
    in_array $file "${excluded[@]}"
    should_install=$?
    if [ $should_install -gt 0 ]; then

      if [ -h "$HOME/$file" ]; then
        rm -rf "$HOME/$file" 2>/dev/null
      fi

      if [ -f "$HOME/$file" ]; then
        if [[ "yes" == $(ask_yes_or_no "$file is a regular file. Remove?") ]]; then
            rm -rf "$HOME/$file" 2>/dev/null
        fi
      fi

      if [ -d "$HOME/$file" ]; then
        if [[ "yes" == $(ask_yes_or_no "$file is a directory. Remove?") ]]; then
            rm -rf "$HOME/$file" 2>/dev/null
        fi
      fi

      if [ ! -e "$HOME/$file" ]; then
        # c_list "$file"
        ln -s "$HOME/.dotfiles/$file" "$HOME/$file"
      else
        e_list "$file"
      fi
    fi
  done

}

in_array() {
  local hay needle=$1
  shift
  for hay; do
    [[ $hay == $needle ]] && return 0
  done
  return 1
}

exclude_non_dotfiles() {
  non_dotfiles=( $(ls) )
  #Combine arrA and arrB
  excluded=( ${excluded[@]} ${non_dotfiles[@]} )
}


#-----------------------------------------------------------------------------
# Initialize
#-----------------------------------------------------------------------------

backupdir="$HOME/.dotfiles-backup/$(date "+%Y%m%d%H%M.%S")"
dependencies=(git vim xmllint)
excluded=(. .. .git .gitmodules)

#-----------------------------------------------------------------------------
# Dependencies
#-----------------------------------------------------------------------------

notice "Checking dependencies"

not_met=0
for need in "${dependencies[@]}"; do
  dep $need
  met=$?
  not_met=$(echo "$not_met + $met" | bc)
done

if [ $not_met -gt 0 ]; then
  error "$not_met dependencies not met!"
  exit 1
fi


#-----------------------------------------------------------------------------
# Install
#-----------------------------------------------------------------------------

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

if [ ! -d $HOME/.dotfiles/.vim/bundle ]; then

 mkdir -p .vim/bundle 
 git clone git://github.com/gmarik/Vundle.vim.git .vim/bundle/Vundle.vim

 install # link .dotfiles including .vim files

 vim +BundleInstall +qall

fi

exclude_non_dotfiles

# Install
notice "Linking"
install

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

