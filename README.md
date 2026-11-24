# dotfiles

Repository holding my [chezmoi](https://www.chezmoi.io/)-managed dotfiles.

## Conceptual divergence

This setup manages machine variations in separate repositories. That keeps public base configuration separate from private or machine-specific repositories (for example, `personal` or `work`), while derived configurations layer on top of `base`.

Because [chezmoi does not support multiple layered sources](https://github.com/twpayne/chezmoi/issues/1169), each repository lives in its own source directory below `$HOME/.local/share/chezmoi/<source>` and runs with `--source`. Where base and derived configurations share a tool or file, `base` exposes drop-in directories, includes, or order-independent `modify_` hooks. (See [discussion #2574](https://github.com/twpayne/chezmoi/discussions/2574) for an alternative merged-source pattern.)

## Setup

1. Run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/timoreimann/dotfiles/master/install.sh)"` to install the base source into `$HOME/.local/share/chezmoi/base`. The same command restores a machine whose home directory was wiped.
1. Start taskbar applications (Rectangle, Clipy) and grant Rectangle the Accessibility permission.
1. Log out and back in, add EurKEY in keyboard settings (under "other" keyboards), and change keyboard in taskbar icon.
1. (Optional) Install additional or derived configurations into `$HOME/.local/share/chezmoi/<other>` and hook up as needed.

## Available hooks

- **zsh:** Provide `$HOME/.zshrc.d/<source>/zshrc` (interactive shells) and `$HOME/.zshrc.d/<source>/zshenv` (all shells).
- **SSH:** Create files below `$HOME/.ssh/config.d/`.
- **Git config:** Provide a `modify_derived` template in `.config/git`. Each source owns one marked section of `~/.config/git/derived`, which `~/.gitconfig` includes last.
- **Global Git ignore:** Provide a `modify_dot_gitignore` template. Each source owns one marked section of `~/.gitignore`.
- **Agent instructions:** Provide `$HOME/.config/agent-instructions/<source>.md`, plus `modify_` templates for `~/.omp/agent/AGENTS.md` and `~/.claude/CLAUDE.md` (import) and `~/.codex/AGENTS.md` (copy). Each source owns one marked section of these files.
- **Agent skills:** Add directories below `$HOME/.agents/skills/`. Public skills that `base` installs are listed in `root/.chezmoidata/skills.yaml`.
- **Ghostty:** Provide `$HOME/.config/ghostty/derived` via the optional `config-file = ?derived` hook in `$HOME/.config/ghostty/config`.
- **wd warp points:** Provide a `modify_dot_warprc` script. Each source keeps the points of other sources.
- **omp settings:** Provide `modify_private_config.yml` in `.omp/agent`. Each source deep-merges its settings and keeps the others.
- **omp MCP servers:** Provide `modify_mcp.json` in `.omp/agent`. Each source deep-merges its servers and settings and keeps the others.
- **Authenticated Homebrew:** Provide `brew-auth` on `PATH` or at `$HOME/bin/brew-auth`. The shared `brew-bundle` template uses `brew-auth` when both `brew-auth` and `op` are available. The initial `base` bootstrap on a new machine runs unauthenticated before derived sources are installed.

Derived sources can call shared `base` templates directly (for example, `section` for marked-section `modify_` templates, or `brew-bundle` for Homebrew package scripts):

```gotmpl
{{- $section := joinPath .chezmoi.sourceDir "../../base/root/.chezmoitemplates/section" -}}
{{- includeTemplate $section (dict "stdin" .chezmoi.stdin "name" "<source>" "content" $content "comment" "# %s" "first" false) -}}
```

## Hook precedence

| Hook                                                                   | Mechanism         | Derived overrides base?                        | Multiple derived sources? |
| ---------------------------------------------------------------------- | ----------------- | ---------------------------------------------- | ------------------------- |
| `~/.zshrc.d/*/zshrc`, `~/.zshrc.d/*/zshenv`                            | Drop-in directory | Yes (sourced after base)                       | Yes                       |
| `~/.ssh/config.d/*`                                                    | SSH `Include`     | No (OpenSSH uses the first value)              | Yes                       |
| `~/.config/git/derived`                                                | Marked sections   | Yes (included after base)                      | Yes                       |
| `~/.gitignore`, `~/.claude/CLAUDE.md`, `~/.omp/agent/AGENTS.md`, Codex | Marked sections   | Order-independent (base is first)              | Yes                       |
| `~/.omp/agent/config.yml`, `~/.omp/agent/mcp.json`, `~/.warprc`        | Deep / set merge  | Non-overlapping keys only (plus base defaults) | Yes                       |
| `~/.config/ghostty/derived`                                            | Optional file     | Yes (loaded after base)                        | No (one file only)        |
| `~/.agents/skills/*`                                                   | Drop-in directory | Independent entries                            | Yes                       |

In `~/.ssh/config`, `base` values (`IdentitiesOnly`, `ServerAliveInterval`, `Host github.com` options) take precedence over `~/.ssh/config.d/*`, except for `Host *` defaults at the bottom of the file. This is the reverse of Git, Ghostty, and zsh.

## Contracts and invariants

All sources share `~/.config/chezmoi/chezmoi.toml` and `~/.config/chezmoi/chezmoistate.boltdb`. Sharing the state database keeps `entryState` consistent for files that multiple sources modify. Follow these rules:

- **Prefix derived script names with the source name** (for example, `run_onchange_after_25-personal-install-packages.tmpl`). Persistent state keys scripts by target path, so script names must be unique across sources.
- **Keep `.chezmoi.toml.tmpl` aligned across sources.** Symlink a derived `root/.chezmoi.toml.tmpl` to `../../base/root/.chezmoi.toml.tmpl`, or have a derived config template write all keys that `base` uses (such as `data.email`). Without a matching config template, `chezmoi` warns about config drift and `apply --force` or `init` clears `base`'s `configState`.
- **Do not overlap enforced keys in merged files.** For `~/.omp/agent/config.yml`, `~/.omp/agent/mcp.json`, and `~/.warprc`, a derived source must set only keys that `base` does not enforce in `settings` (or override keys that `base` puts in `defaults`). Setting the same enforced key in both sources causes alternating diffs on every apply.
- **Do not use `exact_` on shared hook directories** (`~/.agents/skills`, `~/.zshrc.d`, `~/.ssh/config.d`, `~/.config/agent-instructions`). Per-skill externals in `base` scope `exact = true` to each skill directory.
- **Do not add `.chezmoiremove` patterns that match files of derived sources.**
- **Clean up manually when removing a derived source.** Its marked sections, merged settings, and drop-in files remain on disk until you remove them.

## Working with multiple sources

The dotfiles provide a chezmoi wrapper at `$HOME/bin/chezmoi` that simplifies working with multiple sources:

- `-s <source>` (as the first argument) selects a source below `$HOME/.local/share/chezmoi/<source>`.
- `-s all` runs the command against `base` first, then each derived source in alphabetical order, stopping on the first error.
- Explicit `--source` / `-S` flags and source-independent flags or commands (`--version`, `-h`, `--help`, `help`, `completion`, `license`, `upgrade`) pass straight through to `chezmoi`.
- When invoked below `$HOME/.local/share/chezmoi/<source>`, the wrapper selects `<source>` automatically.
- When the vanilla single-source layout (`$HOME/.local/share/chezmoi/.git`) is used, the wrapper behaves identically to vanilla `chezmoi`.
