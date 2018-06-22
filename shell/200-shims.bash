function pbcopy() {
  local -r input="$(cat /dev/stdin)"
  local -r system_pbcopy=$(command -v /usr/bin/pbcopy)

  if [ ! -z "${system_pbcopy}" ]; then
    echo -n "${input}" | ${system_pbcopy}
  elif command -v xclip > /dev/null; then
    echo -n "${input}" | xclip -sel clip
  else
    echo "pbcopy not supported for this OS"
  fi
}
