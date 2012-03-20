#!/bin/bash
# vi:ft=sh
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

test -n "$BASHRC_LOADED" && {
	return
}
BASHRC_LOADED=1

# bring in system bashrc
test -r /etc/bashrc &&
      . /etc/bashrc

# detect interactive shell
case "$-" in
    *i*) INTERACTIVE=yes ;;
    *)   unset INTERACTIVE ;;
esac

# detect login shell
case "$0" in
    -*) LOGIN=yes ;;
    *)  unset LOGIN ;;
esac

test -z "$INTERACTIVE" && {
    # Shell is non-interactive (something like scp). We should exit now!
	return
}
echo "Hello human being"

UNAME="$(uname)"
ME="$(whoami)"

exists () {
	if [[ "$(type $1 2>/dev/null)" == "" ]]; then
		# command not found
		return 1
	else
		# command found
		return 0
	fi
}

# Find a file with a pattern in name:
ff() { 
	find . -type f -iname '*'$*'*' ; 
}

# Aliases
alias a=alias

a rsyncssh="rsync -e ssh --progress --compress --recursive --human-readable --checksum --exclude=*.swp --exclude=WAVECAR --exclude=CHG"
a rsyncsshpartial="rsyncssh --partial-dir=$HOME/.rsync-partial --delay-updates"

a fme="finger | head -n 1; finger | grep $ME"
a v=vim
a m=less
a h='history 20'
a rm="rm -v"                # show which files we actually delete!
a mv='mv -i'                # prompt before overwriting an existing file
a cp='cp -i'                # prompt before overwriting an existing file
a resource='source ~/.bashrc' # re-source, not resource :)
a pl="ps -ef | grep $ME"
a ip="curl -s http://checkip.dyndns.com/ | sed 's/[^0-9\.]//g'"
a localip="ipconfig getifaddr en1"
a httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
a grep='GREP_COLOR="1;32" LANG=C grep --color=auto'

# Dir listing
if [ "$(ls --color 2>/dev/null)" != "" ]; then
    export LS_OPTIONS="--color=auto $LS_OPTIONS" # GNU ls
else
    export LS_OPTIONS="-G $LS_OPTIONS" # FreeBSD ls
fi
LS_OPTIONS="-F $LS_OPTIONS"  # show directories with a trailing '/', executable files with a trailing '*'
a ls="ls $LS_OPTIONS"
a lsd="ls  | grep /"      # List dirs only
a lsl="ls -F | grep @"      # List symbolic links only
a lsx="ls -F -s | grep \*"  # List executables only
a ll="ls -ltrh"
a la="ls -A"

# Play a sound, hollywood style :) Extremely irritating after a while
#alias ls="(afplay -v 0.5 $HOME/Music/soundeffects/select9.wav &); ls"

# Spring cleaning
a vaspclean="rm slurm-* CHG CONTCAR EIGENVAL OSZICAR PCDAT XDATCAR vasprun.xml CHGCAR DOSCAR IBZKPT OUTCAR WAVECAR PROCAR  WAVEDER"

# maui load (titan only?)
a load="showstats | grep 'Current Active'"

# VASP specific
a cpu="grep 'Total CPU time'"
a elapsed="grep 'Elapsed Time  '"
a fermi="grep 'FERMI ENERGY    '"

# Server aliases
a titan='ssh titan.uio.no'
a uio='ssh login.uio.no'
a njord='ssh njord.hpc.ntnu.no'
a stallo='ssh stallo.uit.no'
a hexagon='ssh hexagon.bccs.uib.no'
a 18bg='ssh bergen@login.domeneshop.no'

exists octave && 
    a octave="octave -q"    # quiet startup

# ----------------------------------------------------------------------------------------
# Shell settings

HISTSIZE=9999
unset HISTFILESIZE
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
shopt -s histappend			        # append rather than overwrite the history
shopt -s cdspell                    # Correct minor spelling errors on cd-ing
shopt -s no_empty_cmd_completion    # bash will not attempt to search the PATH for 
                                    # possible completions when completion is 
                                    # attempted on an empty line

if [ -f ~/.bash_prompt ]; then
    source ~/.bash_prompt
fi

# Avoid stack overflow on the execution of the three Fortran programs
# ulimit -s 64000

# Startup file for interactive bash login shells

# Play a welcome sound
#(afplay -v 0.1 $HOME/Music/soundeffects/welcome.wav &)

# LANG 
# export LC_ALL=no_NO.UTF-8
#export LANG=no
export LC_ALL=C     # some programs only work with LC_ALL=C
# LC_COLLATE: Influences sorting order.

# UMASK: 1=x, 2=w, 4=r (rwx=2+4+1=7)
# umask 022   # turn off w for g,o (default)
umask 027     # turn off w for g, rwx for o

export UNAME="$(uname)"
export ME="$(whoami)"
export HOME=~

source $HOME/.bash_functions      # Path functions

echo -e "\033[0;31m $ME @ $(uname -npsr) \c"

# Source programmable bash completion for completion of hostnames, etc.:
if [ -f /opt/local/etc/bash_completion ]; then 
    source /opt/local/etc/bash_completion
elif [ -f /etc/bash_completion ]; then 
    source /etc/bash_completion
else
    source $HOME/.bash_completion
fi


# ----------------------------------------------------------------------------------------
# Paths:

path_prepend $HOME/bin
path_append $HOME/scripts
path_append $HOME/synced/scripts
path_append $HOME/opt/bin


###############################################################################
# Shell behaviors

# Define window title:
#export SHOSTNAME=`hostname -s`
if [ -f $HOME/.hostname ]; then
	export SHOSTNAME=`cat $HOME/.hostname`
else
	export SHOSTNAME=`uname`
fi

# Load machine-specific things
test -f $HOME/.$SHOSTNAME && . $HOME/.$SHOSTNAME

if [ "$TERM" != "dumb" ]; then
    #dircolors
    eval `dircolors ~/.dir_colors`
    #eval `dircolors`
fi

#CCTBX:
#if [ -f "/Users/danmichael/source/cctbx/cctbx_build/setpaths.sh" ]; then
#   . "/Users/danmichael/source/cctbx/cctbx_build/setpaths.sh"
#   export LIBTBX_BUILD="/Users/danmichael/source/cctbx/cctbx_build"
#   path_append PYTHONPATH "/Users/danmichael/source/cctbx/cctbx_sources:/Users/danmichael/source/cctbx/cctbx_sources/clipper_adaptbx:/Users/danmichael/source/cctbx/cctbx_sources/boost_adaptbx:/Users/danmichael/source/cctbx/cctbx_sources/libtbx/pythonpath:/Users/danmichael/source/cctbx/cctbx_build/lib"

#   path_prepend DYLD_LIBRARY_PATH "/Users/danmichael/source/cctbx/cctbx_build/lib"
#fi

#
# This file is synced around and should only contain
# non-machine-specific or system-specific commands
#
#
# http://www.ibm.com/developerworks/linux/library/l-tip-prompt/
#
# 


# Set preferred editor:
export EDITOR=vim

test -n "$INTERACTIVE" -a -n "$LOGIN" && {
	# Interactive login shell. Let's say hello
    uname -npsr
    uptime
    echo "$ME @ $(uname -npsr)"
}

#echo " done"

if [ SHOSTNAME == "mac" ]; then
    # Set PATH for GUI apps as well on Mac:
    launchctl setenv PATH $PATH
    # There's no need to reboot (though you will need to restart an app if you want it to pick up the changed environment.)
fi

echo -e "$NORMAL$RESET"
