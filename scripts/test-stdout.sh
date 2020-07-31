[[ -t 1 ]] && \
    echo 'STDOUT is attached to TTY'

[[ -p /dev/stdout ]] && \
    echo 'STDOUT is attached to a pipe'

[[ ! -t 1 && ! -p /dev/stdout ]] && \
    echo 'STDOUT is attached to a redirection'
