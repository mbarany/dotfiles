[[ -d /usr/local/bin ]] && PATH="/usr/local/bin:$PATH"

[[ -n "$ANDROID_HOME" ]] && PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH"

[[ "$GOPATH" != "" && -d $GOPATH/bin ]] && PATH="$GOPATH/bin:$PATH"

[[ -d $HOME/.composer/vendor/bin ]] && PATH="$HOME/.composer/vendor/bin:$PATH"

[[ -d $DOTFILES_DIR/bin ]] && PATH="$DOTFILES_DIR/bin:$PATH"

[[ -d $HOME/.local/bin ]] && PATH="$HOME/.local/bin:$PATH"

# Remove duplicates from PATH
PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++')
