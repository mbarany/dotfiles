# Take from ~/.ssh/known_hosts
complete -W "$(echo `cat $HOME/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
