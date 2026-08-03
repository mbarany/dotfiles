# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "${PS1}" ] && return

DOTFILES_DIR="$(dirname $(readlink ${HOME}/.bashrc))"
DOTFILES_OS="$(uname -s)"

# Android SDK
if [ -d /usr/local/share/android-sdk ]; then
	export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"
fi

# Completion options
if [ "${DOTFILES_OS}" == "Darwin" ]; then
	# path_helper appends /etc/paths.d/homebrew after /usr/bin, so brew's bash 5 loses the
	# lookup to the stock 3.2. Move the entry to the front rather than only adding it when absent.
	if [[ -d /opt/homebrew/bin ]]; then
		PATH=":${PATH}:"
		PATH="${PATH//:\/opt\/homebrew\/bin:/:}"
		PATH="${PATH#:}"
		PATH="${PATH%:}"
		PATH="/opt/homebrew/bin${PATH:+:${PATH}}"
	fi

	if [ -f $(brew --prefix)/etc/bash_completion ]; then
		source $(brew --prefix)/etc/bash_completion
	fi
fi

# Various shell files
for f in ${DOTFILES_DIR}/shell/*; do [[ -f "${f}" ]] && source ${f}; done
unset f

# load a local specific sources last
[[ -f ${HOME}/.local/bashrc ]] && source ${HOME}/.local/bashrc

unset DOTFILES_DIR

# exit with a success status code
return 0
