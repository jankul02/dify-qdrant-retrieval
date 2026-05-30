# Continue-Specific Rules

**Note:** `.continue/config.yaml` is ignored by Continue — it only loads the global `~/.continue/config.yaml`.
Project-specific rules live in `.continue/rules/*.md` — those ARE loaded.

## Session gate
For any work involving file edits, commits, or scripts: ask the user to type `!start [goal]` first.
Simple read-only questions may proceed without a session.

## Session start
When `!start [goal]` is received, follow the protocol in `.continue/rules/session-prompt.md`.

## Editing files
NEVER use `edit_existing_file` or `create_new_file` — they cause content corruption and Accept/Reject prompts.
ALWAYS use `run_terminal_command` with `cat << EOF > filepath` to write file content.
If a file is corrupted, run `git checkout HEAD -- <file>` to restore it.

## Identifying the correct file to edit
If a file you read says "the correct place for X is file Y", edit file Y.
Do not edit the file that contained the pointer.

## Recommended context to attach manually
- `PROJECT_MAP.md` — for planning or refactoring tasks
- `docs/dev/open_points.md` — for prioritisation discussions
- Relevant source file(s) — Continue does not auto-index everything
