if [ ! -f $HOME/.gitconfig ]; then
    git config --global include.path "$DOTFILES_DIR/.gitconfig"
    git config --global core.excludesfile "$DOTFILES_DIR/.gitignore_global"
fi
