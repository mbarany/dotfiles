# Helper functions used by install scripts

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
