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

