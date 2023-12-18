# List all files colorized in long format, including dot files
alias la="ls -laF -G"
# List only directories
alias lsd="ls -lF -G | grep --color=never '^d'"
# Always use color output for `ls`
alias ls="command ls -G"

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# Get ISO-8601 date
alias date-iso8601="date +%Y-%m-%dT%H:%M:%S%z"

# UUID
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade --all; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update'

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# macOS has no `md5sum`/`sha1sum`, so use `md5`/`shasum` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

if [ "$DOTFILES_OS" == "Darwin" ]; then
  # Hide/show all desktop icons (useful when presenting)
  alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
  alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

  # Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
  # (useful when executing time-consuming commands)
  alias badge="tput bel"

  # Lock the screen (when going AFK)
  alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

  function genpassword() {
    local -r length=${1:-22}
    pwgen --secure --ambiguous --numerals --symbols -1 $length | tee >(pbcopy)
  }
fi

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

# Git
alias wip="git add -A && git commit --no-verify --no-gpg-sign -m 'WIP'"
function unwip() {
    local last_msg=$(git log -1 --pretty=%B)
    if [ "$last_msg" = "WIP" ]; then
        git reset HEAD~1
    else
        echo 'Last commit is not a WIP!'
    fi
}
if command -v hub > /dev/null; then
  alias git=hub
fi
if command -v fork > /dev/null; then
  alias fork='fork status'
fi

# NPM
alias npm-list-globals="npm -g ls --depth 0"

# AWS
alias aws-list="aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | \"\(.Tags | map(select(.Key == \"Name\"))[].Value) || \(.State.Name) || \(.PublicDnsName)\"' | column -s $'\t' -t -s '||' | sort"
aws-sync-bucket () {
  local bucket_name=$1
	aws s3 sync s3://${bucket_name} ./${bucket_name}
}

# prettify JSON
alias pj="ruby -e \"require 'json'; puts JSON.pretty_generate(JSON.parse(ARGF.read))\""

alias pritunl-client="/Applications/Pritunl.app/Contents/Resources/pritunl-client"

alias bin2json="base64 -d | jq"

alias typeless='history 20000 | sed "s/.*  //"  | sort | uniq -c | sort -g | tail -n 100'

alias e='subl .'

alias diff='diff --side-by-side --suppress-common-lines'
