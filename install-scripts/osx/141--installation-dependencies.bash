yes-no() {
  local -r message="$1"
  local response

  read -r -p "${message} [Y/n] " -n 1 response

  if [[ "${response}" == "n" ]]; then
    echo "n"
  else
    echo "y"
  fi
}

no-yes() {
  local -r message="$1"
  local response

  read -r -p "${message} [y/N] " -n 1 response

  if [[ "${response}" == "y" ]]; then
    echo "y"
  else
    echo "n"
  fi
}

brew-install() {
  local package
  local package_version

  for package in "$@"; do
    package_version="$(brew ls --versions ${package} || true)"

    if [ -z "${package_version}" ]; then
      brew install ${package}
    else
      echo -e "Homebrew package ${__COLORS_BLUE}${package}${__COLORS_CLEAR} already installed"
    fi
  done
}

npm-install() {
  local package
  local package_version

  for package in "$@"; do
    package_version="$(npm -g ls --depth 0 ${package})"

    if [ "$?" -ne "0" ]; then
      npm -g install ${package}
    else
      echo -e "NPM package ${__COLORS_BLUE}${package}${__COLORS_CLEAR} already installed"
    fi
  done
}

brew-cask-install-dialog() {
  local args=""
  local arg
  local package
  local package_version

  for arg in "$@"; do
    args+=" \"${arg}\""
  done

  local -r choices=$(echo ${args} | xargs dialog --keep-tite --stdout --checklist 'Choose items to install:' 0 0 0)

  for package in ${choices}; do
    package_version="$(brew cask ls --versions ${package} || true)"

    if [ -z "${package_version}" ]; then
      brew cask install ${package}
    else
      echo -e "Homebrew cask package ${__COLORS_BLUE}${package}${__COLORS_CLEAR} already installed"
    fi
  done
}

brew-install dialog
