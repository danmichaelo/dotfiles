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

if [[ $- != *i* ]] ; then
    # Shell is non-interactive (something like scp). We should exit now!
    return
fi

test -z "$INTERACTIVE" && {
    # Shell is non-interactive (something like scp). We should exit now!
	return
}

# bring in system bashrc
test -r /etc/bashrc &&
      . /etc/bashrc

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

a fme="finger | head -n 1; finger | grep $ME"
a v=vim
a m=less
a h='history 20'
a rm="rm -v"                # show which files we actually delete!
a mv='mv -i'                # prompt before overwriting an existing file
a cp='cp -i'                # prompt before overwriting an existing file
a resource='source ~/.bashrc' # re-source, not resource :)
a pl="ps -ef | grep $ME"

# Dir listing
a lsd='ls -F | grep /'      # List dirs only
a lsl='ls -F | grep @'      # List symbolic links only
a lsx='ls -F -s | grep \*'  # List executables only
a ll='ls -ltrh'
a la='ls -A'
# -F:  show directories with a trailing '/', executable files with a trailing '*'
if [ "$(ls --color 2>/dev/null)" != "" ]; then
	alias ls='ls -F --color'  # GNU ls
else
	alias ls='ls -FG'	# FreeBSD ls
fi

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

if [ "$UNAME" == Darwin ]; then
	# echo "on a mac, hopefully a sane one"
    # perhaps a more sane test would be smart :)
	alias mysql=mysql5
	alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g --remote-silent'
	alias vlc=/Applications/VLC.app/Contents/MacOS/VLC
	alias pfo="open -a Path\ Finder"
	alias math=/Applications/Mathematica.app/Contents/MacOS/MathKernel
	alias bb=bbedit
	alias mp=~/bin/mpost-pdf.pl
	alias skim="open -a Skim.app"

	# Snip for Mathematica batch execution.
	# Usage: mma test.m
	mma () { 
		/Applications/Mathematica.app/Contents/MacOS/MathKernel -noprompt -run
		"<<$1" ; 
	}
	
	# Snip for showing man pages in Preview.
	# Usage: manp <cmd>
	manp() {
		man -t "${1}" | open -f -a Preview
	}

fi

