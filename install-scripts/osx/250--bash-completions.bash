brew tap homebrew/completions
brew install \
    composer-completion \
    gem-completion \
    open-completion \
    vagrant-completion

# Docker Bash Completion
ln -svi /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion /usr/local/etc/bash_completion.d/docker
ln -svi /Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion /usr/local/etc/bash_completion.d/docker-machine
ln -svi /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion /usr/local/etc/bash_completion.d/docker-compose
