function install_php() {
    brew install \
        php70 --with-phpdbg \
        php70-xdebug \
        php70-mcrypt
}

read -r -p "Do you want to install PHP locally? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        install_php
        ;;
    *)
        ;;
esac
