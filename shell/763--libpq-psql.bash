# Put libpq's client binaries (psql, pg_dump, pg_isready, ...) on PATH.
# libpq is keg-only, so brew does not link them. Previously these came from the
# postgresql@16 formula; Postgres now runs in podman via docker-compose, so the
# formula is gone but the clients are still wanted on the host.
LIBPQ_BIN="$(brew --prefix)/opt/libpq/bin"
[ -d "${LIBPQ_BIN}" ] && export PATH="${LIBPQ_BIN}:${PATH}"
