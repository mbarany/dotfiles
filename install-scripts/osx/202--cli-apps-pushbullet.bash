install-pushbullet() {
  local -r package_name="kkpoon-pushbullet-cli"
  local -r package_version="$(npm list --location=global | grep ${package_name})"

  if [[ -z "$package_version" ]]; then
    npm --location=global install ${package_name}
    echo -e "Add the following to your \033[1m$HOME/.local/bashrc\033[0m"
    echo "export PB_ACCESS_TOKEN=<YOUR_PUSHBULLET_ACCESS_TOKEN>"
  fi
}

install-pushbullet
