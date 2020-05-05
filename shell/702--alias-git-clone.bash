git-clone () {
  local -r gihub_repo="${1}"
  git clone "git@github.com:${gihub_repo}.git"
  cd $(basename ${gihub_repo})
}
