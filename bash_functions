#!/bin/sh

# Useful reference: http://mywiki.wooledge.org/Bashism?action=show&redirect=bashism
# http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html

real_dir() {
    CURDIR=`pwd`
    TARGET_FILE=$1
    cd `dirname $TARGET_FILE`
    TARGET_FILE=`basename $TARGET_FILE`
    # Iterate down a (possible) chain of symlinks
    while [ -L "$TARGET_FILE" ]
    do
        TARGET_FILE=`readlink $TARGET_FILE`
        cd `dirname $TARGET_FILE`
        TARGET_FILE=`basename $TARGET_FILE`
    done

    # Compute the canonicalized name by finding the physical path 
    # for the directory we're in and appending the target file.
    PHYS_DIR=`pwd -P`
    RESULT=$PHYS_DIR
    cd $CURDIR
    echo $RESULT
}

# List path entries of PATH or environment variable <var>.
pls() { 
    test -z "$1" && PATHVAR='PATH' || PATHVAR=$1
    echo ${!PATHVAR} | tr ':' '\n'
}
export -f pls

path_remove() {
    NEWPATH=$(echo ${!1} | tr ':' '\n' | grep -v "$2" | paste -d: -s -)
    export $1=$NEWPATH
}
export -f path_remove 

path_prepend() {
    # Example: path_prepend PATH /opt/local/bin
    # If just one argument is given, 'PATH' is taken as the variable
    PATHVAR="$1" DIR="$2"
    test -z "$2" && PATHVAR="PATH" && DIR="$1"
    test ! -d "$DIR" && return # if non-existent
    if test -z "${!PATHVAR}"; then 
        # the path is empty
        export $PATHVAR="$DIR"
    else
        path_remove $PATHVAR $DIR
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
        path_remove $PATHVAR $DIR
        export $PATHVAR="${!PATHVAR}:$DIR"
    fi
}
export -f path_append 


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



