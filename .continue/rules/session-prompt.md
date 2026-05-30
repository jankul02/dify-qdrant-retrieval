# Session Protocol — Dify Qdrant Retrieval Plugin

## Hard Triggers

- **`!start [goal]`**: Execute The Handshake + Knowledge Acquisition.
- **`!end`**: Execute State Sync to formally close the session.
- **`!echo`**: Repeat the last user request exactly, no filler.

## The Handshake

Run `git status` and check `docs/dev/sessions/current.md`.

Traffic Light:
- 🟢 **Clean** — git clean + session closed → proceed
- 🟡 **Attention** — uncommitted changes + session closed → ask: incorporate or set aside?
- 🔴 **Incomplete** — uncommitted changes + session open → ask: resume or fresh start?

## Knowledge Acquisition

Read in order:
1. `docs/dev/sessions/current.md`
2. `PROJECT_MAP.md`
3. `agentic/rules_common.md`
4. `agentic/rules_project.md`
5. `README.md`

Then run `git log --oneline -5`.

## Branch Choice

Ask:
- **[N]ew** `session/YYYY-MM-DD-slug` → `sh scripts/session_start.sh YYYY-MM-DD-slug`
- **[S]tay** on current branch
- **[M]ain** (default branch)

Write goal + start time to `docs/dev/sessions/current.md`.

## In-Session Freedom (ABW — Always Be Working)

Once `!start` is complete and the session is open:

- **No further confirmations needed** for file edits, terminal commands, or script execution within the repo.
- **Full repo access**: read, edit, grep, diff, create, delete files and folders freely.
- **Tool policies**: set all tools to **Automatic** for the duration of the session.

### Hard Safety Exceptions (always ask, never auto)

- `git push --force` / `git push --force-with-lease`
- Dropping Qdrant collections (`DELETE /collections/...`)
- `rm -rf` on paths **outside** the repo root
- Committing secrets (`.env`, tokens, credentials, keys)

## State Sync (!end)

1. Summarize changes (one line).
2. Update `docs/dev/sessions/current.md` (outcome).
3. Append entry to `docs/dev/sessions/history.md`.
4. Update `PROJECT_MAP.md` if files were added or renamed.
5. Update `docs/dev/open_points.md` and `docs/dev/plans.md`.
6. Run `sh scripts/session_end.sh`.
7. **Auto-commit and auto-push** (no confirmation needed on session branches):
   ```bash
   git commit -m 'session: <summary>'
   make session-merge
   git push
   ```
