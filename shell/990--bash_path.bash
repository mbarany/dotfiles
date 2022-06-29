[[ -d ${HOME}/.rvm/bin ]] && PATH="${HOME}/.rvm/bin:${PATH}"

[[ "$GOPATH" != "" && -d ${GOPATH}/bin ]] && PATH="${GOPATH}/bin:${PATH}"

[[ -d ${HOME}/.composer/vendor/bin ]] && PATH="${HOME}/.composer/vendor/bin:${PATH}"

[[ -d ${DOTFILES_DIR}/bin ]] && PATH="${DOTFILES_DIR}/bin:${PATH}"

[[ -d ${HOME}/.local/bin ]] && PATH="${HOME}/.local/bin:${PATH}"

# Local Binaries
PATH="./bin:${PATH}"

# Local Node Binaries
PATH="./node_modules/.bin:${PATH}"
