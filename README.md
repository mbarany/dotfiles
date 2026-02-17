# Michael Barany's dotfiles
[![license](https://img.shields.io/github/license/mbarany/dotfiles.svg)](http://github.com/mbarany/dotfiles/blob/master/LICENSE)

This collection of dotfiles is meant to be installed and be upgradeable.


# Installation

## Dependencies
 - [Homebrew](http://brew.sh/)

```bash
git clone --recursive https://github.com/mbarany/dotfiles.git ~/.dotfiles
~/.dotfiles/install
```

## Other Setup
 - [Git PGP Signing Key](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work)

## Post-Install Steps
These steps require manual action after running the install script:
 - **Chrome PWAs**: Install PWAs for [YouTube Music](https://music.youtube.com) and [Google Meet](https://meet.google.com)
 - **Hammerspoon ShiftIt**: Install the [ShiftIt spoon](https://github.com/peterklijn/hammerspoon-shiftit)
 - **WireGuard**: Install from the [App Store](https://www.wireguard.com/install/)
 - **Home printer**: Set up home printer in System Settings
 - **RubyMine**: Install the .env files support plugin
 - **Google Cloud SDK**: Run `gcloud auth login` to authenticate

## Custom / Local dotfiles
 - See [Local Directory Structure](#local-directory-structure)


# Updating
The install script is used for updates as well. It is idempotent so you need not worry about running it multiple times.
```bash
cd ~/.dotfiles && git pull --recurse-submodules origin master
~/.dotfiles/install
```


# Usage
 - [Scripts](bin/README.md)
 - [Aliases](shell/700--aliases.bash)


# Local Directory Structure
 - `~/.local/bashrc` - Place custom aliases, exports, etc in this file
 - `~/.local/bin/` - Place any custom scripts in this directory
 - `~/.local/bash_completion.d/` - Place any custom bash_completion files in this directory
 - `~/.local/backup-scripts` - Hook from [backup-configs](bin/backup-configs) to backup any custom files and directories
 - `~/.local/install` - Hook from [install](install) to install anything custom

License
=======

    Copyright 2016-2017 Michael Barany

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
