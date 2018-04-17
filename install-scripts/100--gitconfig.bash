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
fi
