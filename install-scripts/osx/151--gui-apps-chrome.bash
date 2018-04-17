if [ ! -f "/Applications/Google Chrome.app" ]; then
  read -r -p "Google Chrome not detected. Install it? [y/N] " response
  case "$response" in
    [yY][eE][sS]|[yY])
      brew cask install google-chrome
      ;;
    *)
      ;;
  esac

  unset response
fi
