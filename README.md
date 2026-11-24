# dotfiles

Repository holding my [chezmoi](https://www.chezmoi.io/)-managed dotfiles.

## conceptual divergence

the given chezmoi usage intends to support a model where machine variations are managed via separate repositories. This can be desired to better separate machine variations by confidentiality (where some configurations might be partially public while others could be hosted in a private repository). Additionally, it can be desired to have a base configuration that more machine-specific configurations build upon.

Unfortunately, [chezmoi does not intend to support this model](https://github.com/twpayne/chezmoi/issues/1169). The suggested workaround is to have separate source directories (and, thus, repositories) and run them in order. This works well when differences can be expressed via separate, non-overlapping files. However, in some cases it may be necessary to refer to a derived, more specific configuration from a base one (e.g., `.zshrc`/`.bashrc` base configurations that need to source derived configurations inline). The given dotfiles enable this kind of coupling in a selective manner.

(For posterity, an apparently more complex approach to yield a similar outcome is described in [this issue](https://github.com/twpayne/chezmoi/discussions/2574).)

## Setup

1. Run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/timoreimann/dotfiles/master/install.sh)"` to install the base source into `$HOME/.local/share/chezmoi/base`. The same command restores a machine whose home directory was wiped.
1. Start taskbar applications (Rectangle, Clipy) and grant Rectangle the Accessibility permission
1. Log out and back in, add EurKEY in keyboard settings (under "other" keyboards), and change keyboard in taskbar icon
1. (Optional) Install additional or derived configurations into `$HOME/.local/share/chezmoi/<other>` and hook up as needed.

## Available hooks

- source additional zsh configuration from a derived source by providing `$HOME/.zshrc.d/<source>/zshrc` (for interactive shells) and `$HOME/.zshrc.d/<source>/zshenv` (for all shells)
- export API tokens by creating the unmanaged file `$HOME/.zshrc.d/secrets`; `~/.zshrc` sources it when it exists
- source additional ssh configuration by creating files below `$HOME/.ssh/config.d/`
- add Git configuration (for example, credentials or URL rewrites for GitHub) with a `modify_derived` template in `.config/git`; each source owns one marked section of `~/.config/git/derived`, which `~/.gitconfig` includes after its own values
- add source-specific agent instructions by providing `$HOME/.config/agent-instructions/<source>.md`, plus modify templates for `~/.omp/agent/AGENTS.md` and `~/.claude/CLAUDE.md` (the import of the file) and for `~/.codex/AGENTS.md` (a copy of the file); each source owns one marked section of these files
- add source-specific Ghostty configuration via the optional `config-file` hook in `$HOME/.config/ghostty/config`; its values override the base configuration
- add wd warp points with another `modify_dot_warprc` script; each source keeps the points of the other sources
- add global Git ignore patterns with another `modify_dot_gitignore` template; each source owns one marked section of `~/.gitignore`
- set omp settings with another `modify_private_config.yml` script in `.omp/agent`; each source deep-merges its settings and keeps the others
- add agent skills as directories below `$HOME/.agents/skills/`; the public skills that base installs are listed in `root/.chezmoidata/skills.yaml`
- provide `brew-auth` on `PATH` or at `$HOME/bin/brew-auth` for authenticated Homebrew runs via the shared `brew-bundle` template

Derived sources can call the `section` template in `root/.chezmoitemplates` directly via `joinPath .chezmoi.sourceDir "../../base/root/.chezmoitemplates/section"`.


## Working with multiple sources

The dotfiles provide a chezmoi wrapper at `$HOME/bin/chezmoi` that simplifies working with multiple sources:

- `-s <source>` (as the first argument) selects a source below `$HOME/.local/share/chezmoi/<source>`.
- `-s all` runs the command against `base` first, then each derived source in alphabetical order, stopping on the first error.
- Explicit `--source` / `-S` flags and source-independent flags or commands (`--version`, `-h`, `--help`, `help`, `completion`, `license`, `upgrade`) pass straight through to `chezmoi`.
- When invoked below `$HOME/.local/share/chezmoi/<source>`, the wrapper selects `<source>` automatically.
- When the vanilla single-source layout (`$HOME/.local/share/chezmoi/.git`) is used, the wrapper behaves identically to vanilla `chezmoi`.
