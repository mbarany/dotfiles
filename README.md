# Michael Barany's dotfiles

## Dependencies
- [Homebrew](http://brew.sh/)

## Installation
```bash
git clone --recursive https://github.com/mbarany/dotfiles.git ~/.dotfiles
~/.dotfiles/install
```

## Updating
The install script is used for updates as well. It is idempotent so you need not worry about running it multiple times.
```bash
cd ~/.dotfiles && git pull --recurse-submodules origin master
~/.dotfiles/install
```

## Other Setup
- [Git PGP Signing Key](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work)

## Usage
### [git-include-config](bin/git-include-config)
This command will let you choose a gitconfig include for the local git repo. It searches your home directory for files that match the pattern `git-config-*`. This essentially lets you have multiple gitconfig global files. For example you could have `git-config-personal` and `git-config-work` which contains your personal email and work email respectively.


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
