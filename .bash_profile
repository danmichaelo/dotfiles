export SHELL=/bin/zsh
exec /bin/zsh -l

[ -f ~/.bashrc ] && . ~/.bashrc

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
. "$HOME/.cargo/env"
