__git_prompt() {
    local s=""
    local branchName=""

    # check if the current directory is in a git repository
    if [ $(git rev-parse --is-inside-work-tree &>/dev/null; printf "%s" $?) == 0 ]; then

        # check if the current directory is in .git before running git checks
        if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == "false" ]; then

            # ensure index is up to date
            git update-index --really-refresh  -q &>/dev/null

            # check for uncommitted changes in the index
            if ! $(git diff --quiet --ignore-submodules --cached); then
                s="$s+";
            fi

            # check for unstaged changes
            if ! $(git diff-files --quiet --ignore-submodules --); then
                s="$s!";
            fi

            # check for untracked files
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                s="$s?";
            fi

            # check for stashed files
            if $(git rev-parse --verify refs/stash &>/dev/null); then
                s="$s$";
            fi

        fi

        # get the short symbolic ref
        # if HEAD isn't a symbolic ref, get the short SHA
        # otherwise, just give up
        branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
                      git rev-parse --short HEAD 2> /dev/null || \
                      printf "(unknown)")"

        [ -n "$s" ] && s=" [$s]"

        printf "%s" "$branchName$s"
    else
        return
    fi
}

__ruby_version() {
  local -r ruby_version="$(command -v rbenv > /dev/null && rbenv local 2> /dev/null)"

  if [[ ! -z "$ruby_version" ]]; then
    echo " [Ruby: $ruby_version]"
  fi
}

__bash_prompt() {
  local ps1=""
  local host_style=""
  local user_style=""
  local -r git_prompt="$(__git_prompt)"

  source $(dirname $(readlink $HOME/.bashrc))/lib/colors.bash

  # logged in as root
  if [[ "${USER}" == "root" ]]; then
      user_style="${__COLORS_BOLD}${__COLORS_RED}"
  else
      user_style="${__COLORS_ORANGE}"
  fi

  # connected via ssh
  if [[ "$SSH_TTY" ]]; then
      host_style="${__COLORS_BOLD}${__COLORS_RED}"
  else
      host_style="${__COLORS_YELLOW}"
  fi

  # username
  ps1+="${user_style}${USER}"

  ps1+="${__COLORS_CLEAR}${__COLORS_WHITE}@"

  # host
  ps1+="${host_style}$(hostname)"

  ps1+="${__COLORS_CLEAR}${__COLORS_WHITE}: "

  # working directory
  ps1+="${__COLORS_GREEN}$(dirs +0)"

  # ruby version
  ps1+="${__COLORS_RED}$(__ruby_version)"

  # git
  if [[ ! -z "${git_prompt}" ]]; then
    ps1+="${__COLORS_WHITE} on ${__COLORS_CYAN}${git_prompt}"
  fi

  ps1+="\n"
  ps1+="${__COLORS_CLEAR}${__COLORS_WHITE}\$${__COLORS_CLEAR} "

  echo -ne "${ps1}"
}

PS1="\$(__bash_prompt)"

# Make new shells get the history lines from all previous
# shells instead of the default "last window closed" history
PROMPT_COMMAND='history -a;'
