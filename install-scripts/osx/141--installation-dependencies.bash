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
    package_version="$(brew ls --cask --versions ${package} || true)"

    if [ -z "${package_version}" ]; then
      brew install --cask ${package}
    else
      echo -e "Homebrew cask package ${__COLORS_BLUE}${package}${__COLORS_CLEAR} already installed"
    fi
  done
}

zip-app-install() {
  local -r app_name="$1"
  local -r url="$2"
  local -r sha256="$3"
  local -r app_path="/Applications/${app_name}.app"

  if [ -d "${app_path}" ]; then
    echo -e "Application ${__COLORS_BLUE}${app_name}${__COLORS_CLEAR} already installed"
    return 0
  fi

  local -r tmp_dir="$(mktemp -d)"

  # ditto (not unzip) so the bundle's symlinks and xattrs survive and the signature stays valid
  if curl -fsSL "${url}" -o "${tmp_dir}/app.zip" \
    && echo "${sha256}  ${tmp_dir}/app.zip" | shasum -a 256 --check --status \
    && ditto -xk "${tmp_dir}/app.zip" "${tmp_dir}/unpacked" \
    && ditto "${tmp_dir}/unpacked/${app_name}.app" "${app_path}"; then
    echo -e "Application ${__COLORS_BLUE}${app_name}${__COLORS_CLEAR} installed"
  else
    echo -e "${__COLORS_RED}Failed to install ${app_name} from ${url}${__COLORS_CLEAR}"
  fi

  rm -rf "${tmp_dir}"
}

brew-install dialog
