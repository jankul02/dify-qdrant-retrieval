# Continue-Specific Rules

Rules and context providers are configured in `.continue/agents/project.yaml`.

**Note:** `.continue/config.yaml` is kept as documentation only — Continue does not load it.
Project-specific rules live in `.continue/rules/*.md` — those ARE loaded.

## Session gate
For any work involving file edits, commits, or scripts: ask the user to type `!start [goal]` first.
Simple read-only questions may proceed without a session.

## Session start
When `!start [goal]` is received:
1. Read `agentic/rules_common.md`, `agentic/rules_project.md`, `PROJECT_MAP.md`, `docs/dev/sessions/current.md`.
2. Run `git status` and `git log --oneline -5`. Report state.
3. Write goal + start time to `docs/dev/sessions/current.md`.
For git ops (branch creation) use the terminal: `sh scripts/session_start.sh YYYY-MM-DD-slug`

## In-Session Freedom (ABW)
Once the session is open after `!start`:
- **No confirmations needed** — edit files, run commands, create/delete folders freely.
- **Tool policies**: set all tools to **Automatic** for the session duration.
- **Hard Safety Exceptions** (always ask, never auto):
  - `git push --force` / `git push --force-with-lease`
  - Dropping Qdrant collections (`DELETE /collections/...`)
  - `rm -rf` on paths **outside** the repo root
  - Committing secrets (`.env`, tokens, credentials, keys)

## Editing files
1. Read the file first with the readFile tool.
2. Prefer `run_terminal_command` with `cat << EOF > filepath` to write the full new content — avoids diff corruption.
3. If the file is corrupted after an edit, immediately run `git checkout HEAD -- <file>` to restore it.

## Identifying the correct file to edit
If a file you read says "the correct place for X is file Y", edit file Y.
Do not edit the file that contained the pointer.

## Recommended context to attach manually
- `PROJECT_MAP.md` — for planning or refactoring tasks
- `docs/dev/open_points.md` — for prioritisation discussions
- Relevant source file(s) — Continue does not auto-index everything
