brew-install \
  open-completion \

command -v vagrant > /dev/null && brew-install vagrant-completion

if command -v docker > /dev/null; then
  # Docker Bash Completion
  ln -sf /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion /usr/local/etc/bash_completion.d/docker
  ln -sf /Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion /usr/local/etc/bash_completion.d/docker-machine
  ln -sf /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion /usr/local/etc/bash_completion.d/docker-compose
fi
