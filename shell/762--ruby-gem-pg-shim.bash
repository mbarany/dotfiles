# Shim for the the pg gem to find libpq
export PKG_CONFIG_PATH="$(brew --prefix)/opt/libpq/lib/pkgconfig"
