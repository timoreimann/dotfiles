# dotfiles

Repository holding my [chezmoi](https://www.chezmoi.io/)-managed dotfiles.

## conceptual divergence

the given chezmoi usage intends to support a model where machine variations are managed via separate repositories. This can be desired to better separate personal vs. work configurations (where the former might be partially public while the latter could be hosted in a company-private repository). Additionally, it can be desired to have a base configuration that more machine-specific configurations build upon.

Unfortunately, [chezmoi does not intend to support this model](https://github.com/twpayne/chezmoi/issues/1169). The suggested workaround is to have separate source directories (and, thus, repositories) and run them in order. This works well when differences can be expressed via separate, non-overlapping files. However, in some cases it may be necessary to refer to a derived, more specific configuration from a base one (e.g., `.zshrc`/`.bashrc` base configurations that need to source derived configurations inline). The given dotfiles enable this kind of coupling in a selective manner.

(For posterity, an apparently more complex approach to yield a similar outcome is described in [this issue](https://github.com/twpayne/chezmoi/discussions/2574).)

## Setup

1. Run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/timoreimann/dotfiles/master/install.sh)"` to install the base source into `$HOME/.local/share/chezmoi/base`
1. Start taskbar applications (Spectacle, Clipy)
1. Log out and back in, add EurKEY in keyboard settings (under "other" keyboards), and change keyboard in taskbar icon
1. (Optional) Install additional or derived configurations into `$HOME/.local/share/chezmoi/<other>` and hook up as needed.

## Available hooks

- source additional zsh configuration by creating files below `$HOME/.zshrc.d/`
- activate extra oh-my-zsh plugins by defining the chezmoi data field `zshPluginsExtra`
- source additional ssh configuration by creating files below `$HOME/.ssh/config.d/`
- change the name of the Github SSH key defining the chezmoi data field `githubKeyName`

Extra data fields can be incorporated by linking from `root/.chezmoidata/<file>` to a destination in a derived `.chezmoidata` configuration. Such links will be chezmoi-ignored automatically if the name is prefixed with `czext-`.

## Working with multiple sources

The dotfiles provide a chezmoi wrapper at `$HOME/bin/chezmoi` that simplifies working with multiple sources:

- The `-s <source>` flag selects a source below `$HOME/.local/share/chezmoi/<source>`.
- When invoking below `$HOME/.local/share/chezmoi/<source>`, the `<source>` directory will be selected automatically.
- When the vanilla chezmoi source directory is used, the wrapper will behave identical to the vanilla `chezmoi` command.
