function install-ruby() {
  brew-install \
    rbenv \
    ruby-build \
    gem-completion \
    bundler-completion \
    libpq
}

[[ "$(yes-no 'Do you want to install Ruby locally?')" == "y" ]] && install-ruby

echo ""
unset -f install-ruby
