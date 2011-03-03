#!/bin/bash
# vi:textwidth=0 foldmethod=marker ft=sh
#
# This file is read by interactive *login* shells (i.e., not all interactive
# shells), and by non-interactive shells started with the --login option.
#
# Basics
#   export LC_ALL=no_NO.UTF-8
#   Quantum Espresso assume that the local language is set to the standard, 
#   i.e. "C":
#export LANG=no
export LC_ALL=C

# The umask shell command changes the umask of the shell process, and all
# processes subsequently started from the shell then inherit the new umask.
# The effect is lost when these processes terminate, e.g. when the user logs
# out. To set an umask permanently, the appropriate umask command can be added
# to a login script.
# default is umask 022. To remove read permission for others, we can set
umask 027

# LC_COLLATE: Influences sorting order.

export UNAME="$(uname)"
export ME="$(whoami)"
export HOME=~
echo -e "$ME @ $(uname -npsr) \c"

# Source programmable bash completion for completion of hostnames, etc.:
test -f /opt/local/etc/bash_completion &&
    . /opt/local/etc/bash_completion

# Path modification functions adapted from Fink's init.sh {{{

# List path entries of PATH or environment variable <var>.
pls () { eval echo \$${1:-PATH} |tr : '\n'; }

# add to end of path
append_path()
{
    # First check if the PATH (1) is empty:
    # if [ -n "$DYLD_LIBRARY_PATH" ]; then
    if eval test -z \"\$$1\"; then
        eval "export $1=\"$2\""
    fi
    
    if ! eval test -z "\"\${$1##*:$2:*}\"" -o -z "\"\${$1%%*:$2}\"" -o -z "\"\${$1##$2:*}\"" -o -z "\"\${$1##$2}\""
    then
        eval "export $1=\"\$$1:$2\""
    fi
}

# add to front of path
prepend_path()
{
    if eval test -z \"\$$1\"; then
        eval "export $1=\"$2\""
    fi

    if ! eval test -z "\"\${$1##*:$2:*}\"" -o -z "\"\${$1%%*:$2}\"" -o -z "\"\${$1##$2:*}\"" -o -z "\"\${$1##$2}\""
    then
        eval "export $1=\"$2:\$$1\""
    fi
}

prepend_path_if_exists()
{
    if [ -d "$2" ]
    then
        prepend_path $1 $2
    fi
}

# }}} 


# ----------------------------------------------------------------------------------------
# Paths:

test -d "$HOME/bin" && prepend_path PATH "$HOME/bin"
test -d "$HOME/scripts" && append_path PATH "$HOME/scripts"
test -d "$HOME/synced/scripts" && append_path PATH "$HOME/synced/scripts"
test -d "$HOME/opt/bin" && append_path PATH "$HOME/opt/bin"

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
	export SHOSTNAME=`cat .hostname`
else
	export SHOSTNAME=`uname`
fi

# Load machine-specific things
test -f .$SHOSTNAME && . .$SHOSTNAME

if [ "$TERM" != "dumb" ]; then
    #dircolors
    eval `dircolors ~/.dir_colors`
    #eval `dircolors`
fi

###############################################################################
# Login shells should grab aliases from .bashrc 
###############################################################################
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
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
