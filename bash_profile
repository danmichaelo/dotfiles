#!/bin/bash
# vi:textwidth=0 foldmethod=marker ft=sh
# Startup file for interactive bash login shells

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
echo -e "$ME @ $(uname -npsr) \c"

# Source programmable bash completion for completion of hostnames, etc.:
test -f /opt/local/etc/bash_completion &&
    source /opt/local/etc/bash_completion

source .bash_functions      # Path functions

# ----------------------------------------------------------------------------------------
# Paths:

prepend_path $HOME/bin
append_path $HOME/scripts
append_path $HOME/synced/scripts
append_path $HOME/opt/bin


###############################################################################
# Build options {{{

if [ "$UNAME" == Darwin ]; then

	# Dette setter opp kompileringsmiljøet til å kompilere på samme måte som Apple
	# har gjort for Snow Leopard, dvs. for tre prosessortyper: Intel 32-bits, Intel
	# 64-bits og PowerPC. Hvorfor Apple har valgt å inkludere PowerPC i dette er
	# litt underlig, men jeg tenker det har med å gjøre at de ikke opprinnelig hadde
	# tenkt å fase ut PowerPC med Snow Leopard. Uansett, med disse besvergelsene før
	# du kjører ./configure vil "ditt" program få samme fat binary som systemets
	# innebygde biblioteker, og det øker sjansen for å linke mot bibliotekene med
	# suksess. 
	
	export MACOSX_DEPLOYMENT_TARGET=10.6 
	#export CFLAGS='-O3 -fno-common -arch i386 -arch x86_64 -arch ppc' 
	#export LDFLAGS='-O3 -arch i386 -arch x86_64 -arch ppc -bind_at_load' 
	#export CXXFLAGS='-O3 -fno-common -arch i386 -arch x86_64 -arch ppc'
	# Print a reminder to self 
	echo -e "[$CFLAGS]\c"
	
	#export F77=g95
	#export FC=g95 
	#  CFLAGS=-m64 CXXFLAGS=-m64 FFLAGS=-m64 FCFLAGS=-m64

fi

# }}}

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
#   append_path PYTHONPATH "/Users/danmichael/source/cctbx/cctbx_sources:/Users/danmichael/source/cctbx/cctbx_sources/clipper_adaptbx:/Users/danmichael/source/cctbx/cctbx_sources/boost_adaptbx:/Users/danmichael/source/cctbx/cctbx_sources/libtbx/pythonpath:/Users/danmichael/source/cctbx/cctbx_build/lib"

#   prepend_path DYLD_LIBRARY_PATH "/Users/danmichael/source/cctbx/cctbx_build/lib"
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
#echo
