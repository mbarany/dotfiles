# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Completion options
if [ -f $(brew --prefix)/etc/bash_completion ]; then
	source $(brew --prefix)/etc/bash_completion
fi
# for f in $(brew --prefix)/etc/bash_completion.d/*; do [[ -f "$f" ]] && source $f; done
for f in ~/.dotfiles/completion/*; do [[ -f "$f" ]] && source $f; done
unset f

# Various shell files
for f in ~/.dotfiles/shell/*; do [[ -f "$f" ]] && source $f; done
unset f

# Android SDK
if [ -d /usr/local/opt/android-sdk ]; then
	export ANDROID_HOME=/usr/local/opt/android-sdk
fi

# load a local specific sources before the scripts
[[ -f ~/.local/bashrc ]] && source ~/.local/bashrc

# set $EDITOR to vi(m) if not already set
[[ -z $EDITOR ]] && EDITOR=$(type vim &> /dev/null && echo vim || echo vi)
export EDITOR=$EDITOR

# exit with a success status code
return 0
