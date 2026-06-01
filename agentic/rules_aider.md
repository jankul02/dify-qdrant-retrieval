# Aider-Specific Rules

Config lives in `.aider.conf.yml`. Session files are pre-loaded read-only via `read:`.

## Thinking mode
If using qwen3, suppress chain-of-thought by starting your first message with `/no_think`.
Example: `/no_think !start improve speed`
Keep responses concise — no multi-step reasoning narration.

## Execution model
You ARE the agent. Do not ask the user to run commands — execute them yourself with `/run`.
`/run <cmd>` executes the command and shows output. Use it directly without asking first.

## Session gate
For any work involving file edits, commits, or scripts: the user types `!start [goal]` first.
Simple read-only questions may proceed without a session.

## Session start
When `!start [goal]` is received, execute immediately in order — no preamble:
1. `/run git status`
2. `/run git log --oneline -5`
3. Report traffic-light state (🟢/🟡/🔴).
4. Ask for branch choice ([N]ew / [S]tay / [M]ain).
5. On [N]: `/run sh scripts/session_start.sh YYYY-MM-DD-slug`
6. `/add docs/dev/sessions/current.md` then write goal + start time.

## In-Session Freedom (ABW)
Once the session is open:
- No confirmations needed — edit files, run `/run` commands freely within the repo.
- Hard Safety Exceptions (always ask): force push, drop Qdrant collections, `rm -rf` outside repo, committing secrets.

## Editing files
Aider applies diffs natively — do NOT use shell heredocs to overwrite files.
Steps for any edit:
1. `/add <file>` to bring it into the editable context.
2. Ask for the change; review the proposed diff.
3. Confirm with `y`.

## Useful aider commands in session
- `/run git status` — check repo state
- `/run git log --oneline -5` — recent commits
- `/add <file>` — add file to edit context
- `/read <file>` — add file as read-only reference
- `/drop <file>` — remove file from context
- `/diff` — show changes made so far
- `/undo` — revert last aider change

## Session end (!end)
When `!end` is received:

First, promote the session files from read-only to editable (they are pre-loaded read-only from config):
```
/add docs/dev/sessions/current.md docs/dev/sessions/history.md PROJECT_MAP.md
```

Then:
1. Summarise changes (one line).
2. Update `docs/dev/sessions/current.md` — fill in the Outcome field.
3. Append entry to `docs/dev/sessions/history.md`.
4. Update `PROJECT_MAP.md` if files were added or renamed.
5. Update `docs/dev/open_points.md` and `docs/dev/plans.md` if needed (`/add` them first).
6. Run each command below via `/run` — aider will ask for confirmation before each one:
   - `/run sh scripts/session_end.sh`
   - `/run git commit -m 'session: <one-line summary>'`
   - `/run make session-merge`
   - `/run git push`
