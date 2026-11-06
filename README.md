# dotfiles

Repository holding my [chezmoi](https://www.chezmoi.io/)-managed dotfiles.

## conceptual divergence

the given chezmoi usage intends to support a model where machine variations are managed via separate repositories. This can be desired to better separate machine variations by confidentiality (where some configurations might be partially public while others could be hosted in a private repository). Additionally, it can be desired to have a base configuration that more machine-specific configurations build upon.

Unfortunately, [chezmoi does not intend to support this model](https://github.com/twpayne/chezmoi/issues/1169). The suggested workaround is to have separate source directories (and, thus, repositories) and run them in order. This works well when differences can be expressed via separate, non-overlapping files. However, in some cases it may be necessary to refer to a derived, more specific configuration from a base one (e.g., `.zshrc`/`.bashrc` base configurations that need to source derived configurations inline). The given dotfiles enable this kind of coupling in a selective manner.

(For posterity, an apparently more complex approach to yield a similar outcome is described in [this issue](https://github.com/twpayne/chezmoi/discussions/2574).)

## Setup

1. Run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/timoreimann/dotfiles/master/install.sh)"` to install the base source into `$HOME/.local/share/chezmoi/base`
1. Start taskbar applications (Rectangle, Clipy) and grant Rectangle the Accessibility permission
1. Log out and back in, add EurKEY in keyboard settings (under "other" keyboards), and change keyboard in taskbar icon
1. (Optional) Install additional or derived configurations into `$HOME/.local/share/chezmoi/<other>` and hook up as needed.

## Available hooks

- source additional zsh configuration from a derived source by providing `$HOME/.zshrc.d/<source>/zshrc` (for interactive shells) and `$HOME/.zshrc.d/<source>/zshenv` (for all shells)
- export API tokens by creating the unmanaged file `$HOME/.zshrc.d/secrets`; `~/.zshrc` sources it when it exists
- source additional ssh configuration by creating files below `$HOME/.ssh/config.d/`
- add source-specific agent instructions by providing `$HOME/.config/agent-instructions/<source>.md`; omp imports it and the Codex copy includes it
- add source-specific Ghostty configuration via the optional `config-file` hook in `$HOME/.config/ghostty/config`; its values override the base configuration
- add wd warp points with another `modify_dot_warprc` script; each source keeps the points of the other sources
- add global Git ignore patterns with another `modify_dot_gitignore` script; each source owns one marked section of `~/.gitignore`
- set omp settings with another `modify_private_config.yml` script in `.omp/agent`; each source deep-merges its settings and keeps the others
- add agent skills as directories below `$HOME/.agents/skills/`; the public skills that base installs are listed in `root/.chezmoidata/skills.yaml`
- change the name of the Github SSH key defining the chezmoi data field `githubKeyName`

Extra data fields can be incorporated by linking from `root/.chezmoidata/<file>` to a destination in a derived `.chezmoidata` configuration. Such links will be chezmoi-ignored automatically if the name is prefixed with `czext-`.

## Working with multiple sources

The dotfiles provide a chezmoi wrapper at `$HOME/bin/chezmoi` that simplifies working with multiple sources:

- The `-s <source>` flag selects a source below `$HOME/.local/share/chezmoi/<source>`.
- When invoking below `$HOME/.local/share/chezmoi/<source>`, the `<source>` directory will be selected automatically.
- When the vanilla chezmoi source directory is used, the wrapper will behave identical to the vanilla `chezmoi` command.
