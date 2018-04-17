INSTALLED_VERSION="$(/usr/local/bin/npm list -g | grep kkpoon-pushbullet-cli)"

if [[ -z $INSTALLED_VERSION ]]; then
  npm -g install kkpoon-pushbullet-cli
  echo -e "Add the following to your \033[1m$HOME/.local/bashrc\033[0m"
  echo "export PB_ACCESS_TOKEN=<YOUR_PUSHBULLET_ACCESS_TOKEN>"
fi

unset INSTALLED_VERSION
