if [ ! -f $HOME/.gitconfig ]; then
  echo "Configuring ~/.gitconfig ..."

  git config --global include.path "$DOTFILES_DIR/.gitconfig"
  git config --global core.excludesfile "$DOTFILES_DIR/.gitignore_global"

  if [ "$DOTFILES_OS" == "Darwin" ]; then
    FULL_NAME=$(id -F)
  else
    FULL_NAME=$(getent passwd $USER | cut -d ':' -f 5 | cut -d ',' -f 1)
  fi
  read -p "Full Name [$FULL_NAME]: " RESPONSE
  RESPONSE=${RESPONSE:-$FULL_NAME}

  git config --global user.name "$RESPONSE"

  unset FULL_NAME
  unset RESPONSE

  read -p "Email: " RESPONSE
  git config --global user.email "$RESPONSE"
  unset RESPONSE

  # Configure SSH signing if a key exists
  if [ -f "$HOME/.ssh/id_github_work" ]; then
    DEFAULT_SIGNING_KEY="$HOME/.ssh/id_github_work.pub"
  elif [ -f "$HOME/.ssh/id_github_personal" ]; then
    DEFAULT_SIGNING_KEY="$HOME/.ssh/id_github_personal.pub"
  fi

  if [ -n "$DEFAULT_SIGNING_KEY" ]; then
    echo ""
    echo "Configuring git commit signing with SSH key..."
    git config --global user.signingkey "$DEFAULT_SIGNING_KEY"
    git config --global gpg.format ssh
    git config --global commit.gpgSign true
    git config --global gpg.ssh.allowedSignersFile "$HOME/.git_allowed_signers"
    git config --global init.defaultBranch main
    echo -e "${__COLORS_GREEN}Git signing configured!${__COLORS_CLEAR}"
  fi
  unset DEFAULT_SIGNING_KEY
fi
