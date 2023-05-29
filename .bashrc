#!/bin/bash
# vi:ft=sh et sw=4 ts=4 ai
#
# This file is sourced on startup by all *interactive* bash shells that are
# *not* login shells.  This file *should generate no output to stdout* or it
# will break the scp and rcp commands (it is not clear to me whether these invoke
# an interactive non-login shell, or a non-interactive shell).  If output is
# desired, it should be directed to stderr rather than stdout.
#
# This is the place for defining shell elements that are not inherited from
# the environment, e.g., aliases and functions.  Shell properties you expect
# to inherit from the login environment (e.g., PATH settings) should be
# in .profile (or .bash_profile or .bash_login) instead.
#
# Non-interactive or interactive *login* shells will instead load .profile
# when they start (if it is found).  Since login shells will never directly
# load .bashrc, the .profile should load it if you want .bashrc shell elements
# to be accessible from login shells.
#
# Inspired by http://www.astro.cornell.edu/staff/loredo/unix2mac/toms.bashrc
# and http://www.stereo.org.ua/2006/bashrc-ps1/
# and https://github.com/rtomayko/dotfiles/blob/rtomayko/.bashrc

unalias -a

# Set a few useful environment variables for later use.
# REAL_HOME is especially useful to have on Toolforge where we commonly
# become another user.


REAL_HOME=$HOME
test -n "$SUDO_USER" && {
    REAL_HOME="`dirname $HOME`/$SUDO_USER"
}
export REAL_HOME

export ME=$( whoami )
export UNAME=$( uname -s )


# Detect if the shell is interactive
case "$-" in
    *i*) export INTERACTIVE=yes ;;
    *)   unset INTERACTIVE ;;
esac

# Detect if the shell is a login shell
case "$0" in
    -*) export LOGIN=yes ;;
    *)  unset LOGIN ;;
esac


umask 002 # turn off w for o only

if [ -n "$INTERACTIVE" ]; then
    echo -e "[\c"
fi

################################################################################
# Define some helper functions

if ! command -v command_exists 2>&1 >/dev/null ; then

    command_exists () {
        if command -v $1 2>&1 >/dev/null; then
            # command found
            return 0
        else
            # command not found
            return 1
        fi
    }
    export -f command_exists

    # Find the real dir (for real!)
    real_dir() {
        CURDIR=`pwd`
        TARGET_FILE=$1
        cd `dirname $TARGET_FILE`
        TARGET_FILE=`basename $TARGET_FILE`
        # Iterate down a (possible) chain of symlinks
        while [ -L "$TARGET_FILE" ]
        do
            TARGET_FILE=`readlink $TARGET_FILE`
            cd `dirname $TARGET_FILE` > /dev/null
            TARGET_FILE=`basename $TARGET_FILE`
        done

        # Compute the canonicalized name by finding the physical path
        # for the directory we're in and appending the target file.
        PHYS_DIR=`pwd -P`
        RESULT=$PHYS_DIR
        cd $CURDIR
        echo $RESULT
    }
    export -f real_dir

    # Find a file with a pattern in name
    ff() {
        find . -type f -iname '*'$*'*' ;
    }
    export -f ff

    cd_reminder() {
        builtin cd "$@"
        if [[ -e .cd-reminder ]]; then
            echo -e "\e[93m━━╢ REMINDER ╟━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            cat .cd-reminder
            echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
        fi
        if [[ -e .reminder ]]; then
            echo -e "\e[93m━━╢ REMINDER ╟━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            cat .reminder
            echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
        fi
    }
    export -f cd_reminder
    alias cd=cd_reminder

    pls() {
        test -z "$1" && PATHVAR='PATH' || PATHVAR=$1
        echo ${!PATHVAR} | tr ':' '\n'
    }
    export -f pls

    path_remove() {
        NEWPATH=$(echo ${!1} | tr ':' '\n' | grep -v "^$2$" | paste -d: -s -)
        export $1="$NEWPATH"
    }
    export -f path_remove

    path_prepend() {
        # Example: path_prepend PATH /opt/local/bin
        # If just one argument is given, 'PATH' is taken as the variable
        PATHVAR="$1" DIR="$2"
        test -z "$2" && PATHVAR="PATH" && DIR="$1"
        # test ! -d "$DIR" && return # if non-existent
        if test -z "${!PATHVAR}"; then
            # the path is empty
            export $PATHVAR="$DIR"
        else
            path_remove $PATHVAR "$DIR"
            export $PATHVAR="$DIR:${!PATHVAR}"
        fi
    }
    export -f path_prepend

    path_append() {
        # Example: path_append MANPATH ~/man
        # If just one argument is given, 'PATH' is taken as the variable
        PATHVAR="$1" DIR="$2"
        test -z "$2" && PATHVAR="PATH" && DIR="$1"
        test ! -d "$DIR" && return # if non-existent
        if test -z "${!PATHVAR}"; then
            # the path is empty
            export $PATHVAR="$DIR"
        else
            path_remove $PATHVAR "$DIR"
            export $PATHVAR="${!PATHVAR}:$DIR"
        fi
    }
    export -f path_append

fi

################################################################################
# Path(s)

#test -n "$INTERACTIVE" && {
#    # UMASK: 1=x, 2=w, 4=r (rwx=2+4+1=7)
#    # umask 022   # turn off w for g,o (default)
#    umask 027   # turn off w for g, rwx for o (useful on shared computers)
#}

# Python virtualenvwrapper, load before machine-specific things so they can set a default environment
# if [[ -z "$SUBSHELL" && -n "$INTERACTIVE" ]]; then
#     export WORKON_HOME=~/.virtualenvs
#     mkdir -p $WORKON_HOME
#     test -f /usr/local/bin/virtualenvwrapper.sh && {
#         . /usr/local/bin/virtualenvwrapper.sh
#     }
# fi

if [ -n "$INTERACTIVE" ]; then
     echo -e ".\c"
fi

# Load local (non-versioned) things
test -f $REAL_HOME/.bashrc.local && . $REAL_HOME/.bashrc.local

if [ -z "$SUBSHELL" ]; then
    path_prepend $REAL_HOME/bin
    path_append $REAL_HOME/scripts
    path_append $REAL_HOME/opt/bin
    path_append $REAL_HOME/.composer/vendor/bin

    # Run things on a per-repo basis if possible:
    path_prepend "./node_modules/.bin"
    path_prepend "./vendor/bin"
fi

if [ -z "$INTERACTIVE" ]; then
    # Shell is non-interactive (something like scp). We should exit now!
    return
fi
echo -e ".\c"

################################################################################
# Interactive-only below:

# Load aliases
test -f $REAL_HOME/.aliases && . $REAL_HOME/.aliases

# Load git-prompt
test -f $REAL_HOME/.git-prompt.sh && . $REAL_HOME/.git-prompt.sh

# Colors

DULL=0
BRIGHT=1
UNDERLINE=4

FG_BLACK=30
FG_RED=31
FG_GREEN=32
FG_YELLOW=33
FG_BLUE=34
FG_VIOLET=35
FG_CYAN=36
FG_WHITE=37

FG_NULL=00

BG_BLACK=40
BG_RED=41
BG_GREEN=42
BG_YELLOW=43
BG_BLUE=44
BG_VIOLET=45
BG_CYAN=46
BG_WHITE=47

BG_NULL=00

##
# ANSI Escape Commands
##
ESC="\033"
NORMAL="$ESC[m"
RESET="$ESC[${DULL}m"

##
# Shortcuts for Colored Text ( Bright and FG Only )
##

# DULL TEXT

BLACK="$ESC[${DULL};${FG_BLACK}m"
RED="$ESC[${DULL};${FG_RED}m"
GREEN="$ESC[${DULL};${FG_GREEN}m"
YELLOW="$ESC[${DULL};${FG_YELLOW}m"
BLUE="$ESC[${DULL};${FG_BLUE}m"
VIOLET="$ESC[${DULL};${FG_VIOLET}m"
CYAN="$ESC[${DULL};${FG_CYAN}m"
WHITE="$ESC[${DULL};${FG_WHITE}m"

# BRIGHT TEXT
BRIGHT_BLACK="\[$ESC[${BRIGHT};${FG_BLACK}m\]"
BRIGHT_RED="\[$ESC[${BRIGHT};${FG_RED}m\]"
BRIGHT_GREEN="\[$ESC[${BRIGHT};${FG_GREEN}m\]"
BRIGHT_YELLOW="\[$ESC[${BRIGHT};${FG_YELLOW}m\]"
BRIGHT_BLUE="\[$ESC[${BRIGHT};${FG_BLUE}m\]"
BRIGHT_VIOLET="\[$ESC[${BRIGHT};${FG_VIOLET}m\]"
BRIGHT_CYAN="\[$ESC[${BRIGHT};${FG_CYAN}m\]"
BRIGHT_WHITE="\[$ESC[${BRIGHT};${FG_WHITE}m\]"

# Check for interactive bash and that we haven't already been sourced.
echo -e ".\c"
# Check for recent enough version of bash.
bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
if [ $bmajor -gt 4 ] || [ $bmajor -eq 4 -a $bminor -ge 1 ]; then
    echo -e "] ${GREEN}Bash $bmajor.$bminor${RESET}\c"
else
    echo -e "] ${RED}[WARNING] Bash $bmajor.$bminor)${RESET}\c"
fi



#echo -e "[H]\c"


# Useful reference: http://mywiki.wooledge.org/Bashism?action=show&redirect=bashism
# http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html

#if [ "$BASH_FUNCTIONS_LOADED" == 1 ]; then
#    echo "R"
#    return
#fi;

# ----------------------------------------------------------------------------------------
# Shell settings

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# HISTIGNORE="rm \*:rm -rf *:rm -r *"  # prevent accidental deletes
# HISTSIZE=9999
# unset HISTFILESIZE
HISTCONTROL=ignoreboth

# Makes bash attempts to save all lines of a multiple-line
# command in the same history entry:
command_oriented_history=1

# Filenames ending with these are ignored while tab completion in bash
export FIGNORE=.o:~:.BAK:.class:.swp

# The noclobber option prevents you from overwriting existing files with
# the > operator. You can use >! to force the file to be written.
set -o noclobber

# From: http://www.ukuug.org/events/linux2003/papers/bash_tips/
shopt -s histappend                 # append rather than overwrite the history
shopt -s cdspell                    # Correct minor spelling errors on cd-ing
shopt -s no_empty_cmd_completion    # bash will not attempt to search the PATH for
                                    # possible completions when completion is
                                    # attempted on an empty line
shopt -s extglob                    # allow for stuff like negative wildards
shopt -s checkwinsize               # check window size after each command

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#test -z "$SUBSHELL" && {
    if [ -f $REAL_HOME/.bash_prompt ]; then
        . $REAL_HOME/.bash_prompt
    fi
#}

# Avoid stack overflow on the execution of the three Fortran programs
# ulimit -s 64000

# Startup file for interactive bash login shells

# Play a welcome sound
#(afplay -v 0.1 $HOME/Music/soundeffects/welcome.wav &)

# LANG
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
#export LC_ALL=C     # some programs only work with LC_ALL=C
# LC_COLLATE: Influences sorting order.

test -n "$SUBSHELL" && {
    echo -e "\033[0;36m\c"
    echo -e " [subshell]\c"
}
echo -e "\033[0;33m\c"

# Source programmable bash completion for completion of hostnames, etc.:
if [ -z "$SUBSHELL" ]; then
    if command_exists brew ; then
        . `brew --prefix`/etc/bash_completion
    elif [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    else
        . $REAL_HOME/.bash_completion
    fi
fi

###############################################################################
# Shell behaviors


# Allow Ctrl-S for forward-search-history
# http://unix.stackexchange.com/questions/12107/how-to-unfreeze-after-accidentally-pressing-ctrl-s-in-a-terminal
stty -ixon

# Specify colors for use with ls
if [ "$TERM" != "dumb" ]; then
    if command_exists dircolors ; then
        eval `dircolors $REAL_HOME/.dir_colors`
    fi
fi

# Set preferred editor
export EDITOR=vim

if [ "$UNAME" == "Darwin" ]; then
    # Set PATH for GUI apps as well on Mac:
    launchctl setenv PATH $PATH
    # There's no need to reboot (though you will need to restart an app if you want it to pick up the changed environment.)
fi

if [ -z "$SUBSHELL" ]; then

    # ----------------------------------------------------------------------------------------
    # NVM

    if [ -d "$REAL_HOME/.nvm" ]; then
        echo -e " [NVM]\c"
        export NVM_DIR="$HOME/.nvm"
        # Mac
        [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"
        # Linux
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi

    # ----------------------------------------------------------------------------------------
    # RVM (Make sure this is the last PATH variable change)

    echo -e " [RVM]\c"
    [[ -s "$REAL_HOME/.rvm/scripts/rvm" ]] && source "$REAL_HOME/.rvm/scripts/rvm"
    # path_append "$HOME/.rvm/bin"

    # ----------------------------------------------------------------------------------------
    # Pipenv

    if command_exists pyenv; then
        echo -e " [Pyenv]\c"
        eval "$(pyenv init -)";
    fi

    if command_exists pipenv ; then
        echo -e " [Pipenv]\c"
        eval "$(pipenv --completion)"
    fi

    # ----------------------------------------------------------------------------------------
    # Travis

    [ -f $HOME/.travis/travis.sh ] && . $HOME/.travis/travis.sh

fi

# ----------------------------------------------------------------------------------------
# Set the SUBSHELL variable (This should be the last thing we do)

export SUBSHELL=1
echo -e "$NORMAL$RESET"
. "$HOME/.cargo/env"
