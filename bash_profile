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
#export LC_ALL=C

# LC_CTYPE: Character classification and case conversion
# We set it to UTF-8 to, among other things, show special characters
# in the terminal. Unfortunately some badly designed code requires it to be 
# set to "C". Therefore, if you run into mysterious errors, try setting 
# it to "C".
# Run 'locale' to check the current value.
export LC_CTYPE=en_GB.UTF-8

# LC_COLLATE: Influences sorting order.

UNAME="$(uname)"
ME="$(whoami)"
HOME=~
echo -e "$ME @ $(uname -npsr) \c"

# Source programmable bash completion for completion of hostnames, etc.:
test -f /opt/local/etc/bash_completion &&
    . /opt/local/etc/bash_completion

############################################################################
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


############################################################################
# Set up environment {{{


# ----------------------------------------------------------------------------------------
# Paths:


test -d "$HOME/bin" && append_path PATH "$HOME/bin"
test -d "$HOME/scripts" && append_path PATH "$HOME/scripts"
test -d "$HOME/synced/scripts" && append_path PATH "$HOME/synced/scripts"
test -d "/opt/local/lib/gromacs/bin" && 
	append_path PATH "/opt/local/lib/gromacs/bin"
test -d "$HOME/Documents/Studier/Master/scripts" && 
	append_path PATH "$HOME/Documents/Studier/Master/scripts" &&
	append_path PYTHONPATH "$HOME/Documents/Studier/Master/scripts"
test -d "/opt/openmpi" &&
    prepend_path PATH /opt/openmpi/bin &&
    append_path DYLD_LIBRARY_PATH /opt/openmpi/lib
    append_path LD_LIBRARY_PATH /opt/openmpi/lib
    append_path MANPATH /opt/openmpi/share/man
test -d "/opt/local/bin" &&
	prepend_path PATH /opt/local/bin:/opt/local/sbin # MacPorts
test -d "/opt/local/Library/Frameworks/Python.framework/Versions/Current/bin" &&
	append_path PATH "/opt/local/Library/Frameworks/Python.framework/Versions/Current/bin"
test -d "/opt/espresso-4.2.1/bin" &&
    append_path PATH "/opt/espresso-4.2.1/bin"


test -d "/usr/local/lib/python2.7/site-packages" &&
	append_path PYTHONPATH "/usr/local/lib/python2.7/site-packages"
test -d "~/includes/python2-7" &&
	append_path PYTHONPATH "~/includes/python2-7"
test -d "$HOME/code/python" &&
	append_path PYTHONPATH "$HOME/code/python"
test -d "$HOME/code/python/ase" &&
	append_path PYTHONPATH "$HOME/code/python/ase"


test -d "/usr/local/man" &&
	append_path MANPATH "/usr/local/man"
test -d "/opt/local/share/man" &&
	append_path MANPATH "/opt/local/share/man" # MacPorts



# ----------------------------------------------------------------------------------------
# Various environment variables:

test -d /opt/intel &&
    . /opt/intel/bin/compilervars.sh intel64 &&
    append_path DYLD_LIBRARY_PATH /opt/intel/mkl/lib
    append_path LD_LIBRARY_PATH /opt/intel/mkl/lib

if [ "$UNAME" == Darwin ]; then

	export DROPBOX=$HOME/Dropbox
	export RSPTHOME=/opt/rspt629
	export GPAW_SETUP_PATH=/usr/share/gpaw-setups-0.5.3574
	
	# Computational Crystallography Toolbox (CCTBX)
	echo -e ".\c"
	#source ~/code/python/_modules/cctbx/cctbx_build/setpaths.sh   # This is relatively time-consuming...
	echo -e ".\c"
	export LIBTBX_BUILD="/Users/danmichael/code/python/_modules/cctbx/cctbx_build"
	
	
	# Platon env:
	PWTDIR=~/tmp/
	
	# RIETAN VENUS env:
	RIETAN=/Applications/RIETAN_VENUS
	ORFFE=$RIETAN
	LST2CIF=$RIETAN
	PRIMA=/Applications/RIETAN_VENUS/
	ALBA=$PRIMA
	export RIETAN ORFFE LST2CIF PRIMA ALBA
	
	# BC: Quiet startup, load mathlib and extension for familiar function names:
	export BC_ENV_ARGS="-q -l $HOME/.bc/extensions.bc $HOME/.bc/bcrc"
	
	# QT env:
	export QTDIR=/opt/local/lib/qt3 # used by qtmake
	
	# XCrysDen env:
	XCRYSDEN_TOPDIR=/opt/XCrySDen-1.5.21-bin-semishared
	XCRYSDEN_SCRATCH=/Users/danmichael/xcrys_tmp
	export XCRYSDEN_TOPDIR XCRYSDEN_SCRATCH
	#PATH="$XCRYSDEN_TOPDIR:$PATH:$XCRYSDEN_TOPDIR/scripts:$XCRYSDEN_TOPDIR/util"

fi

# }}}

echo -e " \c"

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
	export SHOSTNAME='mac'
else
	export SHOSTNAME=`uname`
fi
if [ -f ~/synced/bash_profile ]; then
    . ~/synced/bash_profile
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



# Interaction prompt:
# 
# export PS1="\w\$ "   		# Set default interaction prompt
#
# \[    This sequence should appear before a sequence of characters 
#       that don't move the cursor (like color escape sequences). 
#       This allows bash to calculate word wrapping correctly.
# \]    This sequence should appear after a sequence of non-printing characters.
# 
# \e[30m\]  Color: Black - regular
# \t        the current time in 24-hour HH:MM:SS format
# \[\e[m\]  Reset color 
# \w        the current working directory
#

# Bash shell executes the content of the PROMPT_COMMAND just before displaying
# the PS1 variable
function setXtermTitle {
    RET=$?
	history -a			# Append to history
	if [ "${TERM}" = "xterm" -o "${TERM}" = "xterm-color" ]; then 
		if [ -n "${XTITLE}" ]; then 
			echo -ne "\033]0;${XTITLE}\007"
		else 
			WDIR=`echo ${PWD} | sed -e "s@${HOME}@\~@"`
			echo -ne "\033]0;${USER}@${SHOSTNAME}:${WDIR}\007" 
		fi
	fi
	#echo -n "[$(date +%k:%M)]"
    RED='\e[0;31m'
    GREEN='\e[0;32m'

    #return value visualisation
    #RET_SMILEY=`if [[ $RET = 0 ]]; then echo -ne "\[$GREEN\];)"; else echo -ne "\[$RED\];("; fi;`
    #
    #RET_VALUE='$(echo $RET)' #Ret value not colorized - you can modify it.
    
    if [[ $RET = 0 ]]; then
       IPROMPT="\[\e[32m\]\t\[\e[0m\] \W\$ "
    else
       IPROMPT="\[\e[32m\]\t\[\e[0m\] \[\e[4;31m\][$RET]\[\e[0m\] \W\$ "
    fi
    PS1="$IPROMPT"
}

export PROMPT_COMMAND='setXtermTitle'
export PS2=" > "			# Set continuation interactive prompt



#test -n "$INTERACTIVE" -a -n "$LOGIN" && {
	# Interactive login shell. Let's say hello
    #uname -npsr
    #uptime
    #echo "$ME @ $(uname -npsr)"
#}

#echo " done"
echo
