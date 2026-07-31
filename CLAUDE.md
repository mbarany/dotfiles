# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commits and pushes are human-only

Never run `git add`, `git commit`, or `git push` in this repository, on any branch, even when asked to "commit this" as a follow-up. Leave changes in the working tree and report what changed and which files. Michael commits and pushes this repo by hand.

Read-only git commands (`status`, `diff`, `log`, `branch`) are fine.

## What this is

Michael Barany's personal macOS/Linux dotfiles, cloned to `~/.dotfiles`. Pure bash. No build step, no test suite, no CI, no linter config. `install` doubles as the updater, so **every change must stay idempotent**.

## Commands

```bash
./install                     # full install/update; interactive throughout (dialog checklists, read prompts, sudo)
bash -n path/to/file.bash     # syntax check, the closest thing to a test in this repo
shellcheck -s bash file.bash  # not a repo dependency; pre-existing code has known SC2086 noise
reload                        # alias for `exec $SHELL -l`
```

Install scripts are sourced, not executed, so they cannot be run standalone. To exercise one in isolation, reproduce the caller's environment first:

```bash
DOTFILES_DIR=$PWD DOTFILES_OS=$(uname -s) bash -c '
  set -o errexit -o nounset -o pipefail
  source lib/colors.bash
  source install-scripts/050--functions.bash
  source install-scripts/osx/141--installation-dependencies.bash
  # then source the one script under test'
```

Most `install-scripts/osx/15*` scripts block on a `dialog` checklist or a `yes-no` prompt, so never source them from an unattended agent session. To test a helper instead of a whole script, call it directly after the prelude above, and point it at a scratch directory rather than `/Applications`.

## Architecture

Three independent `for f in <dir>/*; do source $f; done` pipelines. Files are sourced in lexical order, so **the numeric filename prefix is the ordering contract**. Renumbering changes behavior.

| Pipeline | Entry point | Sources, in order | Ends with |
|---|---|---|---|
| Install | `install` | `install-symlinks.bash`, `install-scripts/*`, then `install-scripts/osx/*` or `linux/*` per `uname -s` | `~/.local/install` |
| Shell | `~/.bashrc` (symlink) | `shell/*` | `~/.local/bashrc` |
| Completion | `~/.bash_completion` (symlink) | `bash_completion.d/*` | `~/.local/bash_completion.d/*` |

`install-symlinks.bash` is what wires `~/.bashrc`, `~/.bash_profile`, `~/.bash_completion`, `~/.crontab`, `~/.inputrc`, `~/.curlrc`, and `~/.hushlogin` back into this repo. It only links when the target is not already a symlink.

### Install scripts inherit the caller's shell options

They have no shebang and set no options of their own. They run under `set -o errexit -o nounset -o pipefail` from `install`.

Consequence: a trailing `[[ cond ]] && cmd` that evaluates false returns non-zero and aborts the entire install. Existing scripts dodge this by keeping statements after such a line (see `300--dev-ruby.bash`). Prefer an explicit `if` block, which is safe in any position.

Same reason: a helper that can fail should print a red error and return 0, not propagate failure, so one bad download does not kill the whole run.

### Idempotency lives in check-then-act helpers

`install-scripts/osx/141--installation-dependencies.bash` holds the installers. Each skips and prints "already installed" rather than reinstalling:

- `brew-install <pkg>...` guards on `brew ls --versions`
- `brew-cask-install-dialog <token> <label> <on|off>...` renders a `dialog` checklist, then guards on `brew ls --cask --versions`
- `zip-app-install <app-name> <url> <sha256>` guards on `/Applications/<app-name>.app`, then curl, sha256 verify, `ditto`. For apps with no Homebrew cask. It uses `ditto` rather than `unzip` so bundle symlinks and xattrs survive and the code signature stays valid.

`install-scripts/050--functions.bash` adds `yes-no` / `no-yes` prompts, used for optional things that are not part of a cask checklist.

Match the existing guards when adding install steps: `symlink` tests `-L`, `200--gitconfig.bash` only runs when `~/.gitconfig` is absent, `100--ssh-keys.bash` skips key paths that already exist.

### The shell pipeline depends on the symlink

`.bashrc` and `.bash_completion` derive the repo path with `dirname $(readlink $HOME/.bashrc)`, not from `BASH_SOURCE`. Sourcing them directly out of the repo does not work; `~/.bashrc` must be the symlink.

`shell/800--bash_prompt.bash` builds the prompt and is the only shell file that sources `lib/colors.bash` and `lib/icons.bash`. Its segments (`__git_prompt`, `__kubectl_context`, `__ruby_version`, `__pulumi_stack`, `__battery_status`) run on every prompt, so they must be non-blocking and degrade silently when a tool, file, or network is missing. Battery is the pattern for anything slow: `.cron` runs `~/.crontab/ps1-all` every 5 minutes, which fans out over `.crontab/ps1/*` in the background to write `/tmp/ps1_battery_status`, and the prompt only reads that file.

### ~/.local escape hatches

Machine-specific config never belongs in this repo. Five optional hooks, all loaded last: `~/.local/bashrc`, `~/.local/bin/`, `~/.local/bash_completion.d/`, `~/.local/install`, `~/.local/backup-scripts`.

### submodules/

One submodule, `bashmarks`, sourced by `shell/750--vendor.bash`. Clone with `--recursive`. Vendoring a dependency here without a matching `source` line in `750--vendor.bash` leaves dead weight, which is how `resty`, `yarn-completion`, and `keybase-completion` accumulated before being removed.

### bin/

`shell/990--bash_path.bash` puts `bin/` on PATH. Unlike the rest of the repo these are standalone executables with a shebang and the executable bit. `bin/README.md` documents every one of them; keep it in sync when adding or removing a script.

A command that has to change the caller's directory cannot live here, because `bin/` scripts run in a subshell. `git-clone` was moved out to `shell/702--alias-git-clone.bash` for exactly that reason (commit `16715fc`), and `bin/README.md` links to it there.

## Gotchas

- `install-scripts/osx/900--crontab.bash` merges `.cron` into the existing crontab inside `# BEGIN dotfiles` / `# END dotfiles` markers, preserving unrelated entries. It also drops any unmarked copy of a line it is about to add, so re-running cannot duplicate a job. Anything added to `.cron` inherits that behavior; do not reintroduce `crontab -r`.
- Homebrew casks get deprecated and disabled (`utc-menu-clock` was removed for failing the macOS Gatekeeper check). When a cask dies and no replacement exists, use `zip-app-install` with a pinned URL and sha256, and leave a comment linking the upstream download page so the pin can be bumped.
- README lists post-install steps that the script deliberately does not automate (Chrome PWAs, Hammerspoon ShiftIt spoon, WireGuard from the App Store, printer setup, RubyMine .env plugin, `gcloud auth login`).
