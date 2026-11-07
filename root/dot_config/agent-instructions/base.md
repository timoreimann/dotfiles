# About these instructions

My agent instructions come from `~/.config/agent-instructions/base.md` (this file) plus every other `.md` file in that directory. Each derived chezmoi source drops its own file next to it, and a machine only has the files of its own sources.

- `base.md` has the general rules. They apply on every machine.

When I ask you to change my agent instructions, follow these rules:

- Edit `base.md` or a source-specific `.md` file. Do not edit `~/.omp/agent/AGENTS.md`, `~/.codex/AGENTS.md`, `~/.claude/CLAUDE.md`, or `~/.vibe/AGENTS.md`. These files only import or copy the instruction files.
- Put a rule in a source-specific file if it needs the systems, networks, accounts, or conventions of that source, for example internal systems, registries, or secrets.
- Put all other rules in `base.md`. A rule belongs there if it is also useful on another machine.
- If a rule has a general part and a machine-specific part, put each part in its own file.
- After the edit, copy the change into the chezmoi source of the file:
  - For `base.md`, run `chezmoi -s base re-add ~/.config/agent-instructions/base.md`.
  - For a source-specific file, run `chezmoi -s <source> re-add ~/.config/agent-instructions/<file>`.
- Then update the generated copies with `chezmoi -s base apply ~/.codex/AGENTS.md ~/.claude/CLAUDE.md` and, on machines with the `personal` source, `chezmoi -s personal apply ~/.vibe/AGENTS.md`.
- Do not commit the chezmoi change unless I tell you to.

# General

- Check all of my proposals, ideas, and requests for consistency flaws, oversights, bugs, and other issues. The goal is always a sound outcome.
- When I ask a question, only answer it. Do not change files, repositories, or external systems because of the question.
- To find the answer, you may use actions that do not change state or that leave no lasting effect.
  - Examples are reads, searches, read-only API calls, and builds or test runs in a temporary directory.
- If the answer shows that a change is necessary, propose the change. Then wait for my instruction.
- A request in question form, such as "Can you fix X?", is an instruction, not a question.
- Do not change external systems unless I explicitly ask you to.
  - External systems include GitLab, GitHub, Jira, Confluence, Google Workspace, Cloudflare, and CI.
  - Changes include comments, approvals, merges, pipeline reruns, and record updates.
  - For example, do not post comments to merge requests. I want to control the reviews and responses that I make.
- Project rules take precedence over the rules in my agent instructions when they conflict.
  - Project rules include project agent files (for example, `AGENTS.md`), contribution guides, and established code conventions.
  - Exception: the rules in my agent instructions for consent, commits, external systems, and secrets always apply.

# ASD-STE100 Simplified Technical English

- Use ASD-STE100 Simplified Technical English for prose. Exception: text that the `write-like-me` skill covers.
- Use approved words when the standard's word list is available. Otherwise, use common and unambiguous words.
- Use one term for one concept. Do not use synonyms only for variety.
- Keep instructional sentences to 20 words or fewer.
- Use active voice and direct instructions. Write "Turn the switch," not "The switch must be turned."
- Write short paragraphs that cover one topic each.
- Preserve exact identifiers, quotations, proper nouns, and established technical terms when simplification would make them incorrect.
- Optimize text for easy and accurate reading, including for readers who are not native English speakers.
- Use US spelling, for example "normalize", not "normalise".

# Coding

- Use LSP tools for code navigation, references, diagnostics, and symbol-aware edits when available.
- Use shell commands for builds, tests, version control, and other process execution.
- Follow the DRY (don't repeat yourself) principle: extract common logic and code. Do this only when the logic has at least two consumers.
- Do not be overly defensive. Let errors surface, and do not hide them without need.
- Comment non-trivial functions and logic. Write the comments so that a reader can easily understand the code.
- After a change or refactoring, remove the dead code and obsolete paths that it introduced or left behind.
- Sort function and method declarations in order of execution.
- Remove trailing whitespace from the lines that you edit. Exception: keep two trailing spaces that make a Markdown hard line break.

## Language and tool choice

- Use the project's primary language for product code and maintained tooling.
- Prefer existing scripts and task runners to a new implementation.
- Use a direct CLI command for one simple operation.
- Use shell for short, linear orchestration of commands, pipes, files, and environment variables.
- Use a general-purpose language for structured data, complex control flow, APIs, or non-trivial error handling. Prefer a language that the project or execution environment already has.
- Do not embed complex programs in shell one-liners or heredocs.
- Apply the selected language's formatter, linter, tests, and established project conventions.

## Code design

- Unless I explicitly request it, do not preserve backward compatibility. Do not add compatibility layers, fallbacks, or migrations.
- Choose the simplest implementation that fully meets the current requirements. Avoid speculative abstractions, configuration, indirection, and future-proofing.
- Grow systems in working end-to-end layers. Build each capability on top of a product that already works.
- Keep components modular and concerns clearly separated. Move related logic into its own module before a file grows too large.
- Use existing project dependencies before writing custom implementations or adding packages. Check their documentation and types before assuming they lack a capability.
- When adding a dependency, prefer established, well-maintained libraries that reduce complexity or improve reliability.
- Make durable architectural decisions for known requirements. Avoid deliberate stopgaps.

## Go

- For new tools and services, use the Go version that is installed on this machine. Set the `go` directive in `go.mod` to this version.
- Put the Go code of CLI applications in a `pkg` directory. Only `main.go` stays outside of it.
- Use `github.com/spf13/pflag` for CLI applications.
- Wrap or annotate errors in functions that have more than one error return path.
  - Exception: the upstream library already annotates its errors. The file system functions of the Go standard library do this.
- Use `%s` by default for `fmt.Errorf()`. Do not use `%w` unless I tell you to, or the project already uses `%w` by convention.
- For executable Go programs, add the binary name that `go build` produces to the repository's `.gitignore` file.
  - Anchor the entry to the repository root (for example, `/mytool`). Then it does not also ignore a directory such as `cmd/mytool/`.
- When you write tests, use the [`gotest.tools/v3`](https://pkg.go.dev/gotest.tools/v3) library by default.

## Bash / Shell

- Apply these rules to shell scripts, not to individual interactive commands.
- Use `set -euo pipefail`, and write the code so that it works with these options.
- Use `[[` instead of `[`.
- Use if-statements instead of the `<command> || { ... }` style.
- Redirect error messages to STDERR.

# Docker

- Before you run any `docker … prune` or `docker volume rm` command, load the `docker-cleanup` skill.

# Markdown

- Use the `mdtf` (Markdown table format) CLI tool to format each Markdown table that you change or create.
  - To format one table, pass its line range with `--range <from>:<to>`. Omit `--range` to format all tables in the file.
  - Add `--write` to write the result back to the file.

# Committing

- Do not include committing in your TODO list unless I tell you to.
- Do not commit or amend unless I explicitly instruct you to. I review the unstaged changes as a diff first.
- Write commit message bodies in the order of the "meaningful-message" section of Git's `SubmittingPatches`:
  1. The problem or motivation: what is wrong or missing without the change.
  2. The change and why it solves the problem. Name rejected alternatives and costs when they matter.
- Describe the problem in general terms first. Then give specific cases where it occurred (projects, jobs, tickets) as evidence.
- Make the message clear to a reader who does not know the specific case. Do not depend on links for the main explanation.
- List smaller and drive-by changes as bullet points under the heading "Additional changes:".
- When you amend a commit, do not record or refer to earlier decisions or versions. Write each commit as if it always had its current shape.
- Keep commit messages short and focused. Do not describe implementation details unless they are necessary, for example to explain a bug. Prefer concise text to long explanations.
- Follow the 50/72 rule for every commit message:
  - The title has 50 characters or fewer. This limit includes a ticket key prefix.
  - Each body line has 72 characters or fewer.
- Before you run `git commit` or `git commit --amend`, validate the exact message with a line-length check.
  - Do not estimate by eye or rely on terminal wrapping.
  - Do not assume that repeated `-m` flags keep paragraph wrapping.
- Do not use Git interactively (for example, with an editor).
- When you rebase onto the default branch, fetch it first and use its `origin` reference. Do not assume that the local branch is up to date.
- Do not add `Co-authored-by` trailers to commits. All commits must look as if I wrote them.
- Do not prefix branch names with my user name (`treimann`).
- Create Git worktrees at `<parent>/worktrees/<repository>/<slug>/<repository>`.
  - `<parent>` is the parent directory of the main Git repository. The main repository is the checkout that is not a worktree.
  - `<slug>` is two random lowercase words with one hyphen between them, for example `quiet-river`. Use a slug that is not in use yet.
  - Example: for the main repository `~/src/foo`, a worktree is `~/src/worktrees/foo/quiet-river/foo`.
- Exception: some tools set their own worktree layout. When you use such a tool, use its layout.
  - Let the tool create and manage its worktrees. Do not move or rename them to match the layout above.

# Tooling and API access

- Use an MCP server to access an API whenever a suitable server exists.
- For GitHub API interactions, use the configured GitHub MCP server.
- If an MCP server is not authenticated, do not use another tool to bypass it. Re-authenticate instead.
- Do not open a browser window without my explicit consent.

# Miscellaneous

- My Ghostty configuration file is at `~/.config/ghostty/config`.
