# bash completion for git-clone

_git-clone_cache_file() {
  echo "${HOME}/.cache_github_repo_names"
}

_git-clone_curl_github() {
  local -r url="${1}"

  curl --silent -H "Authorization: token ${GITHUB_TOKEN}" "${url}"
}

_git-clone_get_me() {
  echo "https://api.github.com/user/repos"
}

_git-clone_get_orgs() {
  _git-clone_curl_github "https://api.github.com/user/orgs" | jq --raw-output ".[].repos_url"
}

_git-clone_get_repos() {
  local -r repos_url="${1}"
  local -r page="${2}"

  _git-clone_curl_github "${repos_url}?page=${page}&per_page=100" | jq --raw-output ".[].full_name"
}

_git-clone_get_all_repos() {
  local repos_url="${1}"
  local all_repos=""
  local i=1

  local repos
  while true; do
    repos="$(_git-clone_get_repos $repos_url $i)"
    if [[ -z "${repos}" ]]; then
      break
    fi
    all_repos="${all_repos} ${repos}"
    i=$((i+1))
  done
  echo $all_repos
}

_git-clone_cache_all_repos() {
  local -r cache_file="$(_git-clone_cache_file)"
  local -ar repos_urls=("$(_git-clone_get_me) $(_git-clone_get_orgs)")
  local repos=""
  local repos_url

  for repos_url in "${repos_urls[@]}"; do
    repos="${repos} $(_git-clone_get_all_repos ${repos_url})"
  done
  echo "${repos}" > "${cache_file}"
}

_git-clone_completions() {
  local -r cur_word="${COMP_WORDS[COMP_CWORD]}"
  local -r prev_word="${COMP_WORDS[COMP_CWORD-1]}"
  local -r cache_file="$(_git-clone_cache_file)"

  # Build cache for first run
  if [[ ! -f "${cache_file}" ]]; then
      echo -ne "\033[s"
      echo -ne "\nFirst run! Fetching Github repos for cache..."
      _git-clone_cache_all_repos 2> /dev/null
      echo -ne "\r                                             "
      echo -ne "\033[u"
  fi

  # Refresh cache
  local -r should_recache="$(find ${cache_file} -mmin +5)"
  if [[ -n "${should_recache}" ]]; then
    (_git-clone_cache_all_repos 2> /dev/null &)
  fi

  local -ar word_list=($(cat "${cache_file}"))

  if [ ${#word_list[@]} -eq 0 ]; then
    echo -ne "\nError! Could not find any repos! Make sure you have a valid 'GITHUB_TOKEN' set with the 'repo' scope."
    rm -f "${cache_file}"
    return 1
  fi

  if [[ ${prev_word} == "git-clone" ]] ; then
      COMPREPLY=($(printf "%s\n" "${word_list[@]}" | grep -i "${cur_word}"))
  else
      COMPREPLY=()
  fi

  return 0
}

complete -F _git-clone_completions git-clone
