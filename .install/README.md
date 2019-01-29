# README

Expects dotfiles integration guide from [here](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/) to be applied with configuration repository sitting at `$HOME/.cfg`.

Steps:

- pull in timoreimann/secrets
- copy SSH keys from timoreimann/secrets to $HOME/.ssh
- import base SSH configuration
- cherry-pick from .zshrc
- install brew packages via brew.sh
- Terminal: install Solarized Dark theme + Powerline fonts (to be used with "agnoster" zsh theme
- max window with cmd+f: install Spectacle and configure
- non-breaking white space (pipe in shell + "not found" problem): Install Karabiner (Elements) -> Settings -> Complex Modifications -> Add Rule -> Import More Rules... -> Change alt+spacebar to spacebar -> click "Enable"
- clip board: install CopyClip (Mac app)
- Java: install via brew
