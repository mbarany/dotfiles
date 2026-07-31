brew-cask-install-dialog \
  hammerspoon "Hammerspoon" on \
  hiddenbar "Hidden Bar" on \
  jiggler "Jiggler" on \
  1password "1Password" off \
  safeincloud-password-manager "SafeInCloud Password Manager" on \
  strongvpn "StrongVPN" on \
  localsend "LocalSend" on \
  notunes "noTunes" on

# Replaces the utc-menu-clock cask, deprecated 2026-09-01 for failing the Gatekeeper check.
# No cask exists, so the URL/checksum are pinned: bump from https://sindresorhus.com/utc-time#non-app-store-version
if [[ "$(yes-no 'Do you want to install UTC Time (menu bar clock)?')" == "y" ]]; then
  zip-app-install \
    "UTC Time" \
    "https://www.dropbox.com/scl/fi/t98b3p4kebmb7hrmahms4/UTC-Time-1.11.0-1769179922.zip?rlkey=2i3xk1wm2okqh1237rfkbuj3t&raw=1" \
    "4df6a4aa370727639d0d5e03f9bf3e85b4348b29ed4752873b8fcbfeff7715d8"
fi
