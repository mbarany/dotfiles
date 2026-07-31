GCLOUD_PATH_INC="$(brew --prefix)/share/google-cloud-sdk/path.bash.inc"
[ -s "${GCLOUD_PATH_INC}" ] && source "${GCLOUD_PATH_INC}"
unset GCLOUD_PATH_INC
