#!/bin/bash
# vi:textwidth=0 foldmethod=marker ft=sh
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

###############################################################################
# Login shells should grab aliases from .bashrc 
###############################################################################
if [ -f $HOME/.bashrc ]; then
    . $HOME/.bashrc
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




#test -n "$INTERACTIVE" -a -n "$LOGIN" && {
	# Interactive login shell. Let's say hello
    #uname -npsr
    #uptime
    #echo "$ME @ $(uname -npsr)"
#}

#echo " done"
echo -e "$NORMAL$RESET"
