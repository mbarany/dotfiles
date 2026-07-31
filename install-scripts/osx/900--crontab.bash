install-dotfiles-crontab() {
  local -r begin_marker="# BEGIN dotfiles"
  local -r end_marker="# END dotfiles"
  # `crontab -l` exits non-zero when no crontab exists yet, which errexit would treat as fatal
  local -r existing="$(crontab -l 2> /dev/null || true)"

  {
    if [ -n "${existing}" ]; then
      # Drop the previous managed block, plus any unmarked copy of a line we are about to add,
      # so upgrading from the pre-marker layout does not duplicate the entry
      printf '%s\n' "${existing}" | awk -v b="${begin_marker}" -v e="${end_marker}" '
        NR == FNR { if (length($0)) managed[$0] = 1; next }
        $0 == b { skip = 1; next }
        $0 == e { skip = 0; next }
        skip { next }
        $0 in managed { next }
        { print }
      ' "${DOTFILES_DIR}/.cron" -
    fi

    echo "${begin_marker}"
    cat "${DOTFILES_DIR}/.cron"
    echo "${end_marker}"
  } | crontab -
}

install-dotfiles-crontab

unset -f install-dotfiles-crontab
