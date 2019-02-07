# README

Expects dotfiles integration guide from [here](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/) to be applied with configuration repository sitting at `$HOME/.cfg`.

Steps:

- pull in timoreimann/secrets
- copy SSH keys from timoreimann/secrets to $HOME/.ssh
- import base SSH configuration
- [install oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh#basic-installation)
- cherry-pick from .zshrc
- always allow application installations from unidentified developers (works in Mojave): `sudo spctl --master-disable` (check _Security & Privacy_ afterwards to be sure)
- install brew packages via brew.sh
- install non-brew applications: Visual Studio Code (vscode), Docker for Mac
- restore vscode settings via [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync)
- install the [vscode CLI integration](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line) (Shift+Command+P --> `shell command`)
- [install Solarized Dark theme + Powerline fonts for iterm2](https://gist.github.com/kevin-smets/8568070) (to be used with "agnoster" zsh theme)
- max window with cmd+f: install Spectacle and configure
- clip board: install CopyClip (Mac app)
