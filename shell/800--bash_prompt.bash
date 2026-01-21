__git_prompt() {
    local status=""
    local branch_name=""

    # check if the current directory is in a git repository
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        return
    fi

    # check if the current directory is in .git before running git checks
    if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == "false" ]; then

        # REMOVED: git update-index --really-refresh (this is SLOW)
        # The git status checks below are fast enough without it

        # check for uncommitted changes in the index
        if ! git diff --quiet --ignore-submodules --cached 2>/dev/null; then
            status="${status}+";
        fi

        # check for unstaged changes
        if ! git diff-files --quiet --ignore-submodules -- 2>/dev/null; then
            status="${status}!";
        fi

        # check for untracked files
        if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
            status="${status}?";
        fi

        # check for stashed files
        if git rev-parse --verify refs/stash &>/dev/null; then
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
}

__ruby_version() {
  command -v rbenv &>/dev/null || return
  rbenv local 2>/dev/null
}

__kubectl_context() {
  # Skip if kubectl not installed or no config exists
  [[ ! -f "${HOME}/.kube/config" ]] && return

  awk '
    $1 == "current-context:" { print $2 }
  ' ~/.kube/config 2>/dev/null
}

__pulumi_stack() {
  [[ ! -f "Pulumi.yaml" ]] && return
  command -v pulumi > /dev/null && pulumi stack --show-name 2> /dev/null
}

__battery_status() {
  [[ ! -f "/tmp/ps1_battery_status" ]] && return

  local -r battery_status="$(cat /tmp/ps1_battery_status)"
  local battery_status_bar=""

  if [[ -n "${battery_status}" ]]; then
    if [[ "${battery_status}" -le "5" ]]; then
      battery_status_bar="${__COLORS_BG_BRIGHT_RED}${__COLORS_WHITE} ${__ICON_BATTERY_EMPTY}"
    elif [[ "${battery_status}" -le "25" ]]; then
      battery_status_bar="${__COLORS_BG_ORANGE}${__COLORS_WHITE} ${__ICON_BATTERY_QUARTER}"
    elif [[ "${battery_status}" -le "50" ]]; then
      battery_status_bar="${__COLORS_BG_BRIGHT_YELLOW}${__COLORS_BLACK} ${__ICON_BATTERY_HALF}"
    elif [[ "${battery_status}" -le "75" ]]; then
      battery_status_bar="${__COLORS_BG_GREEN}${__COLORS_BLACK} ${__ICON_BATTERY_THREE_QUARTERS}"
    fi

    if [[ -n "${battery_status_bar}" ]]; then
      echo -ne "${battery_status_bar} ${battery_status}% ${__COLORS_CLEAR}"
    fi
  fi
}

__set_tab_title() {
    local title=""
    if [[ -f ".git/tabtitle" ]]; then
        title=$(<.git/tabtitle)   # read the file contents
    else
        title="${PWD##*/}"        # fallback: current folder name
    fi
    echo -ne "\033]0;${title}\a"
}

__timer_last="0"
__timer_start() {
  __timer=${__timer:-${SECONDS}}
}
__timer_stop() {
  if [[ -n "${__timer}" ]]; then
    __timer_last=$((${SECONDS} - ${__timer}))
  fi
  __timer=""
}
trap '__timer_start' DEBUG

__bash_prompt() {
  if [[ -z "$(command -v __git_prompt)" ]]; then
    echo '\u@\h - \w\n\$ '
    return 0
  fi

  local ps1=""
  local -r git_prompt="$(__git_prompt)"
  local -r ruby_version="$(__ruby_version)"
  local -r kubectl_context="$(__kubectl_context)"

  ps1+="$(__battery_status)"

  # username & host
  ps1+="${__COLORS_BG_PURPLE}${__COLORS_WHITE}"' \u@\h '"${__COLORS_CLEAR}"

  # working directory
  ps1+="${__COLORS_BG_BLUE}${__COLORS_BLACK}"' \w '"${__COLORS_CLEAR}"

  # kubectl context
  if [[ -n "${kubectl_context}" ]]; then
    ps1+="${__COLORS_BG_ORANGE}${__COLORS_WHITE} ${__ICON_K8S} ${kubectl_context} ${__COLORS_CLEAR}"
  fi

  # ruby version
  if [[ -n "${ruby_version}" ]]; then
    ps1+="${__COLORS_BG_RED}${__COLORS_WHITE} ${__ICON_RUBY} ${ruby_version} ${__COLORS_CLEAR}"
  fi

  # git
  if [[ -n "${git_prompt}" ]]; then
    ps1+="${__COLORS_BG_GREEN}${__COLORS_BLACK} ${__ICON_GIT_BRANCH} ${git_prompt} ${__COLORS_CLEAR}"
  fi

  # shell level
  if [[ "${SHLVL}" -gt '1' ]]; then
    ps1+="${__COLORS_BG_CYAN}${__COLORS_WHITE} ${__ICON_TERMINAL_LEVEL} ${SHLVL} ${__COLORS_CLEAR}"
  fi

  # number of background jobs
  if [[ -n "$(jobs -p)" ]]; then
    ps1+="${__COLORS_BG_BRIGHT_YELLOW}${__COLORS_BLACK} ${__ICON_GEAR}"' \j '"${__COLORS_CLEAR}"
  fi

  # execution time of last command
  if [[ "${__timer_last}" -gt '3' ]]; then
    ps1+="${__COLORS_BG_RED}${__COLORS_WHITE} ${__ICON_TIMER_SAND} ${__timer_last}s ${__COLORS_CLEAR}"
  fi

  # shell exit code of last command
  if [[ "${__exit_code}" -ne '0' ]]; then
    ps1+="${__COLORS_BG_RED}${__COLORS_WHITE} ${__ICON_BUG} ${__exit_code} ${__COLORS_CLEAR}"
  fi

  ps1+="\n"

  ps1+="${__COLORS_WHITE}"'\$'"${__COLORS_CLEAR}  "

  echo -ne "${ps1}"
}

source $(dirname $(readlink $HOME/.bashrc))/lib/colors.bash
source $(dirname $(readlink $HOME/.bashrc))/lib/icons.bash

# Store exit code and run prompt function directly - no need to re-declare function each time
__prompt_command() {
  __exit_code=$?  # Make it global so __bash_prompt can access it
  history -a
  __set_tab_title
  command -v __timer_stop > /dev/null && __timer_stop || true

  if [[ "${USER}" == "root" ]]; then
    PS1="${__COLORS_RED}"'\w\$'"${__COLORS_CLEAR} "
  else
    PS1="$(__bash_prompt)"
  fi
}

PROMPT_COMMAND='__prompt_command'
