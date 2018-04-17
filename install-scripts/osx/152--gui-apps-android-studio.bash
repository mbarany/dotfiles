if ! $(brew cask ls --versions android-studio > /dev/null 2&1); then
  read -r -p "Install Android Studio? [y/N] " response
  case "$response" in
    [yY][eE][sS]|[yY])
      brew cask install android-studio
      ;;
    *)
      ;;
  esac

  unset response
fi
