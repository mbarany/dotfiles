if command -v direnv > /dev/null; then
  eval "$(direnv hook bash)"
  export DIRENV_LOG_FORMAT=""
fi
