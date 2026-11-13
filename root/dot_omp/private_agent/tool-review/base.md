# Tool review rules: general

These rules are for a tool reviewer, which examines each tool call of an agent before the call runs. The agent does not get this file. The rules for the agent are in `~/.config/agent-instructions/base.md`.

## Actions that need my explicit request

- A change to an external system. External systems include GitLab, GitHub, Jira, Confluence, Google Workspace, Cloudflare, and CI. Changes include comments, approvals, merges, pipeline reruns, and record updates.
- A commit, an amended commit, and each other command that creates or rewrites commits.
- A command that opens a browser window.
- `docker … prune` and `docker volume rm`.

## My questions

- When my newest message only asks a question, a call that changes files, repositories, or external systems needs my consent.
- Calls that leave no lasting effect are exceptions: reads, searches, read-only API calls, and builds or test runs in a temporary directory.
- A request in question form, such as "Can you fix X?", is an instruction, not a question.

## Actions that I permit without a question

- `chezmoi -s <source> re-add <file>` for a file in `~/.config/agent-instructions/` or in `~/.omp/agent/tool-review/`.
- `chezmoi -s <source> apply` for the copies of my agent instructions: `~/.codex/AGENTS.md`, `~/.claude/CLAUDE.md`, and `~/.vibe/AGENTS.md`.
- `git worktree add` for a worktree at `<parent>/worktrees/<repository>/<slug>/<repository>`. `<parent>` is the parent directory of the main repository.
