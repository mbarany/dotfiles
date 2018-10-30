symlink() {
  local -r from="$1"
  local -r to="$2"

  if ! test -L ${to}; then
    ln -si ${from} ${to}
  fi
}

symlink ${DOTFILES_DIR}/.hushlogin ${HOME}/.hushlogin
symlink ${DOTFILES_DIR}/.curlrc ${HOME}/.curlrc
symlink ${DOTFILES_DIR}/.inputrc ${HOME}/.inputrc
symlink ${DOTFILES_DIR}/.bashrc ${HOME}/.bashrc
symlink ${DOTFILES_DIR}/.bash_profile ${HOME}/.bash_profile
symlink ${DOTFILES_DIR}/.bash_completion ${HOME}/.bash_completion

unset -f symlink
