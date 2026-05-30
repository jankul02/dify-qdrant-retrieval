# Continue-Specific Rules

Rules and context providers are configured in `.continue/config.yaml`.

## Session gate
For any work involving file edits, commits, or scripts: ask the user to type `!start [goal]` first.
Simple read-only questions may proceed without a session.

## Session start
When `!start [goal]` is received:
1. Read `agentic/rules_common.md`, `agentic/rules_project.md`, `PROJECT_MAP.md`, `docs/dev/sessions/current.md`.
2. Run `git status` and `git log --oneline -5`. Report state.
3. Write goal + start time to `docs/dev/sessions/current.md`.
For git ops (branch creation) use the terminal: `sh scripts/session_start.sh YYYY-MM-DD-slug`

## Editing files
1. Read the file first with the readFile tool.
2. Use `editExistingFile` with `old_string` / `new_string` format.
3. If the file is corrupted after an edit, immediately run `git checkout HEAD -- <file>` to restore it, then retry using `writeFile` with the complete new content.

## Identifying the correct file to edit
If a file you read says "the correct place for X is file Y", edit file Y.
Do not edit the file that contained the pointer.

## Recommended context to attach manually
- `PROJECT_MAP.md` — for planning or refactoring tasks
- `docs/dev/open_points.md` — for prioritisation discussions
- Relevant source file(s) — Continue does not auto-index everything
