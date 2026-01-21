# https://gist.github.com/premek/6e70446cfc913d3c929d7cdbfe896fef

mv() {
  if [ "$#" -ne 1 ] || [ ! -e "$1" ]; then
    command mv "$@"
    return
  fi

  read -ei "$1" newfilename
  command mv -v -- "$1" "$newfilename"
}
