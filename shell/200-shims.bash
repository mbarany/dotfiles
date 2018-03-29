function pbcopy {
  if [ "$DOTFILES_OS" == "Darwin" ]; then
    pbcopy "$@"
  elif [ "$DOTFILES_OS" == "Linux" ]; then
    xclip -selection clipboard "$@"
  else
    echo "pbcopy not supported for this OS"
  fi
}
