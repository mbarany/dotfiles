# source the users bashrc if it exists
if [ -f $HOME/.bashrc ]; then
  source $HOME/.bashrc
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
