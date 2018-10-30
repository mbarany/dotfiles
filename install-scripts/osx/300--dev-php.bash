function install-php() {
  brew install \
    php71 --with-phpdbg \
    php71-xdebug \
    php71-mcrypt \
    composer
}

[[ "$(no-yes 'Do you want to install PHP/composer locally?')" == "y" ]] && install-php

echo ""
unset -f install-php
