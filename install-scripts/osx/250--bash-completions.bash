brew-install \
  open-completion \

command -v vagrant > /dev/null && brew-install vagrant-completion

# Docker Bash Completion
if command -v docker > /dev/null; then
  etc=/Applications/Docker.app/Contents/Resources/etc
  ln -sf ${etc}/docker.bash-completion $(brew --prefix)/etc/bash_completion.d/docker
  ln -sf ${etc}/docker-machine.bash-completion $(brew --prefix)/etc/bash_completion.d/docker-machine
  ln -sf ${etc}/docker-compose.bash-completion $(brew --prefix)/etc/bash_completion.d/docker-compose
  unset etc
fi
