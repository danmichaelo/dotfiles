#!/bin/sh

# Useful reference: http://mywiki.wooledge.org/Bashism?action=show&redirect=bashism

# List path entries of PATH or environment variable <var>.
pls () { 
    test -z "${!1}" && echo $PATH || echo ${!1}
}
export -f pls

strip_from_path() {
    NEWPATH=$(echo ${!1} | tr ':' '\n' | grep -v "$2" | paste -d: -s -)
    export $1=$NEWPATH
}
export -f strip_from_path

prepend_path() {
    # Example: prepend_to_path PATH /opt/local/bin
    # If just one argument is given, 'PATH' is taken as the variable
    KEY="$1" VAL="$2"
    test -z "${!2}" && KEY="PATH" && VAL="$1"
    test ! -d "$VAL" && return # if non-existent
    if test -z "${!KEY}"; then 
        # the path is empty
        export $KEY="$VAL"
    else
        strip_from_path $KEY $VAL
        export $KEY="$VAL:${!KEY}"
    fi 
}
export -f prepend_path

append_path() {
    # Example: append_to_path MANPATH ~/man
    # If just one argument is given, 'PATH' is taken as the variable
    KEY="$1" VAL="$2"
    test -z "${!2}" && KEY="PATH" && VAL="$1"
    test ! -d "$VAL" && return # if non-existent
    if test -z "${!KEY}"; then 
        # the path is empty
        export $KEY="$VAL"
    else
        strip_from_path $KEY $VAL
        export $KEY="${!KEY}:$VAL"
    fi 
}
export -f append_path

