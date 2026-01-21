git-clone() {
  local -r github_repo="${1}"
  git clone "git@github.com:${github_repo}.git"
  cd "$(basename "${github_repo}")"
}
