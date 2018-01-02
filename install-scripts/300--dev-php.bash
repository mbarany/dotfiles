function install_php() {
    brew install \
        php71 --with-phpdbg \
        php71-xdebug \
        php71-mcrypt
}

read -r -p "Do you want to install PHP locally? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        install_php
        ;;
    *)
        ;;
esac
