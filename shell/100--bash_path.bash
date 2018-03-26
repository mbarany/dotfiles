[[ -d /usr/local/bin ]] && PATH="/usr/local/bin:$PATH"

[[ -d $HOME/.rvm/bin ]] && PATH="$HOME/.rvm/bin:$PATH"

[[ -n "$ANDROID_HOME" ]] && PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH"

[[ "$GOPATH" != "" && -d $GOPATH/bin ]] && PATH="$GOPATH/bin:$PATH"

[[ -d $HOME/.composer/vendor/bin ]] && PATH="$HOME/.composer/vendor/bin:$PATH"

[[ -d $DOTFILES_DIR/bin ]] && PATH="$DOTFILES_DIR/bin:$PATH"

[[ -d $HOME/.local/bin ]] && PATH="$HOME/.local/bin:$PATH"

# Local Composer Binaries
PATH="./vendor/bin:$PATH"

# Local Node Binaries
PATH="./node_modules/.bin:$PATH"


# Remove duplicates from PATH
remove_dups() {
    local D=${2:-:} path= dir=
    while IFS= read -d$D dir; do
        [[ $path$D =~ .*$D$dir$D.* ]] || path+="$D$dir"
    done <<< "$1$D"
    printf %s "${path#$D}"
}
PATH=$(remove_dups "$PATH")

unset -f remove_dups
