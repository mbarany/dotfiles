# Copy global gitconfig template
if [ ! -f $HOME/.gitconfig ]; then
    cp -i $DIR/templates/.gitconfig $HOME/.gitconfig
fi
