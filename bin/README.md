# [appify](appify)
Creates the simplest possible Mac app from a shell script. See `appify --help` for more info.

# [backup-configs](backup-configs)
Backup script that zips up local files and sends them to the server of your choice via rsync.

# [git-clone](../shell/702--alias-git-clone.bash)
Wraps `git clone` and adds [bash completion](../bash_completion.d/git-clone.bash) for Github repos. Make sure to add a `GITHUB_TOKEN` to your `.bashrc`. Lives in `shell/` rather than here because it `cd`s into the clone, which a subshell script cannot do.

# [git-include-config](git-include-config)
This command will let you choose a .gitconfig include for the local git repo. It searches your home directory for files that match the pattern `.git-config-*`. This essentially lets you have multiple .gitconfig global files. For example you could have `.git-config-personal` and `.git-config-work` which contains your personal email and work email respectively.

# [git-log-pretty-oneline](git-log-pretty-oneline)
Print a pretty oneline git log with author

# [git-proon](git-proon)
Finds deleted remote branches and deletes the local references as well as any matching local branches

# [git-pull-recursive](git-pull-recursive)
Does a recursive `git pull`.

# [hiddenfiles](hiddenfiles)
Turns on the display of **hidden files** in Finder. Use `hiddenfiles hide` to turn it back off.

# [kc](kc)
Switch `kubectl` context interactively. Uses `fzf` when available, otherwise falls back to a `select` menu.

# [myip](myip)
Shows you your IP Addresses. `myip public` shows you your public IP. `myip local` shows you your local IP. `myip all` shows you all of your local IP's.

# [pr-reviewer](pr-reviewer)
Get a PR reviewer [or 2 or 3 or n] from a Github team. `pr-reviewer github-team-id [ num_reviewers ] [ excluded_user ... ]`

# [prune-backups](prune-backups)
Prune backups

# [setup-dotfiles-for-contribution](setup-dotfiles-for-contribution)
Repoints `~/.dotfiles` `origin` at `git@github.com:mbarany/dotfiles.git`, so a clone made over HTTPS can push.

# [update-git-origin-url-to-ssh](update-git-origin-url-to-ssh)
Rewrites one repo's `origin` from an HTTPS Github URL to the SSH equivalent. `update-git-origin-url-to-ssh <repository_directory>`

# [urldecode](urldecode)
URL decode a string

# [urlencode](urlencode)
URL encode a string

# [whiteboard-cleaner](whiteboard-cleaner)
Cleans up an image of a whiteboard
