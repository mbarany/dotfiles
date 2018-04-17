if ! $(brew cask ls --versions phpstorm > /dev/null 2&1); then
  read -r -p "Install phpstorm? [y/N] " response
  case "$response" in
    [yY][eE][sS]|[yY])
      brew cask install phpstorm
      ;;
    *)
      ;;
  esac

  unset response
fi
