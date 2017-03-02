# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

DOTFILES_DIR="$(dirname $(readlink $HOME/.bashrc))"

# Android SDK
if [ -d $HOME/Library/Android/sdk ]; then
	export ANDROID_HOME=$HOME/Library/Android/sdk
fi

# Completion options
if [ -f $(brew --prefix)/etc/bash_completion ]; then
	source $(brew --prefix)/etc/bash_completion
fi

# Various shell files
for f in $DOTFILES_DIR/shell/*; do [[ -f "$f" ]] && source $f; done
unset f

# load a local specific sources before the scripts
[[ -f $HOME/.local/bashrc ]] && source $HOME/.local/bashrc

# set $EDITOR to vi(m) if not already set
[[ -z $EDITOR ]] && EDITOR=$(type vim &> /dev/null && echo vim || echo vi)
export EDITOR=$EDITOR

# exit with a success status code
return 0
