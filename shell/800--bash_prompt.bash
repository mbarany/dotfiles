__git_prompt() {
    local status=""
    local branch_name=""

    # check if the current directory is in a git repository
    if [ $(git rev-parse --is-inside-work-tree &>/dev/null; printf "%s" $?) == 0 ]; then

        # check if the current directory is in .git before running git checks
        if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == "false" ]; then

            # ensure index is up to date
            git update-index --really-refresh  -q &>/dev/null

            # check for uncommitted changes in the index
            if ! $(git diff --quiet --ignore-submodules --cached); then
                status="${status}+";
            fi

            # check for unstaged changes
            if ! $(git diff-files --quiet --ignore-submodules --); then
                status="${status}!";
            fi

            # check for untracked files
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                status="${status}?";
            fi

            # check for stashed files
            if $(git rev-parse --verify refs/stash &>/dev/null); then
                status="${status}$";
            fi

        fi

        # get the short symbolic ref
        # if HEAD isn't a symbolic ref, get the short SHA
        # otherwise, just give up
        branch_name="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
                      git rev-parse --short HEAD 2> /dev/null || \
                      printf "(unknown)")"

        [ -n "$status" ] && status=" [$status]"

        printf "%s" "${branch_name}${status}"
    else
        return
    fi
}

__ruby_version() {
  command -v rbenv > /dev/null && rbenv local 2> /dev/null
}

__kubectl_context() {
  command -v kubectl > /dev/null && kubectl config current-context &> /dev/null && kubectl config current-context
}

__battery_status() {
  [[ ! -f "/tmp/ps1_battery_status" ]] && return

  local -r battery_status="$(cat /tmp/ps1_battery_status)"
  local battery_status_bar=''

  if [[ -n "${battery_status}" ]]; then
    if [[ "${battery_status}" -le "5" ]]; then
      battery_status_bar="${__COLORS_BG_BRIGHT_RED}${__COLORS_WHITE} ${__NF_BATTERY_EMPTY}"
    elif [[ "${battery_status}" -le "25" ]]; then
      battery_status_bar="${__COLORS_BG_ORANGE}${__COLORS_WHITE} ${__NF_BATTERY_QUARTER}"
    elif [[ "${battery_status}" -le "50" ]]; then
      battery_status_bar="${__COLORS_BG_BRIGHT_YELLOW}${__COLORS_BLACK} ${__NF_BATTERY_HALF}"
    elif [[ "${battery_status}" -le "75" ]]; then
      battery_status_bar="${__COLORS_BG_GREEN}${__COLORS_BLACK} ${__NF_BATTERY_THREE_QUARTERS}"
    fi

    if [[ -n "${battery_status_bar}" ]]; then
      echo -ne "${battery_status_bar}  ${battery_status}% ${__COLORS_CLEAR}"
    fi
  fi
}

__timer_last="0"
__timer_start() {
  __timer=${__timer:-${SECONDS}}
}
__timer_stop() {
  __timer_last=$((${SECONDS} - ${__timer}))
  unset __timer
}
trap '__timer_start' DEBUG

__bash_prompt() {
  if [[ "${USER}" == "root" ]]; then
    echo "\001$(tput setaf 124)\002   \001$(tput sgr0)\002 "
    return 0
  fi

  if [[ -z "$(command -v __git_prompt)" ]]; then
    echo '\u@\h - \w\n$ '
    return 0
  fi

  local ps1=""
  local -r git_prompt="$(__git_prompt)"
  local -r ruby_version="$(__ruby_version)"
  local -r kubectl_context="$(__kubectl_context)"

  source $(dirname $(readlink $HOME/.bashrc))/lib/colors.bash
  source $(dirname $(readlink $HOME/.bashrc))/lib/nerd_font_icons.bash

  ps1+="$(__battery_status)"

  # username & host
  ps1+="${__COLORS_BG_PURPLE}${__COLORS_WHITE} ${__NF_USER} \u${__NF_DIVIDER}${__NF_COMPUTER} \h ${__COLORS_CLEAR}"

  # working directory
  ps1+="${__COLORS_BG_BLUE}${__COLORS_BLACK} ${__NF_FOLDER} \w ${__COLORS_CLEAR}"

  # kubectl context
  if [[ -n "${kubectl_context}" ]]; then
    ps1+="${__COLORS_BG_ORANGE}${__COLORS_WHITE} ${__NF_K8S} ${kubectl_context} ${__COLORS_CLEAR}"
  fi

  # ruby version
  if [[ -n "${ruby_version}" ]]; then
    ps1+="${__COLORS_BG_RED}${__COLORS_WHITE} ${__NF_RUBY} ${ruby_version} ${__COLORS_CLEAR}"
  fi

  # git
  if [[ -n "${git_prompt}" ]]; then
    ps1+="${__COLORS_BG_GREEN}${__COLORS_BLACK} ${__NF_GIT_BRANCH} ${git_prompt} ${__COLORS_CLEAR}"
  fi

  # shell level
  if [[ "${SHLVL}" -gt '1' ]]; then
    ps1+="${__COLORS_BG_ORANGE}${__COLORS_WHITE} ${__NF_TERMINAL_2} ${SHLVL} ${__COLORS_CLEAR}"
  fi

  # number of background jobs
  if [[ -n "$(jobs -p)" ]]; then
    ps1+="${__COLORS_BG_BRIGHT_YELLOW}${__COLORS_BLACK} ${__NF_BICYCLE} \j ${__COLORS_CLEAR}"
  fi

  # execution time of last command
  if [[ "${__timer_last}" -gt '3' ]]; then
    ps1+="${__COLORS_BG_RED}${__COLORS_WHITE} ${__NF_TIMER_SAND}${__timer_last}s ${__COLORS_CLEAR}"
  fi

  # shell exit code of last command
  if [[ "${__exit_code}" -ne '0' ]]; then
    ps1+="${__COLORS_BG_RED}${__COLORS_WHITE} ${__NF_BUG} ${__exit_code} ${__COLORS_CLEAR}"
  fi

  ps1+="\n"

  ps1+="${__COLORS_WHITE}${__NF_TERMINAL}${__COLORS_CLEAR}  "

  echo -ne "${ps1}"
}

PS1="\$(__exit_code=\$?; $(declare -f __bash_prompt); __bash_prompt)"

# Make new shells get the history lines from all previous
# shells instead of the default "last window closed" history
PROMPT_COMMAND='history -a; command -v __timer_stop > /dev/null && __timer_stop || true'
