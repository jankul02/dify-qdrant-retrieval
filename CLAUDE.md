# Dify Qdrant Retrieval Plugin — Agent Entry Point

**Read these before doing anything else:**
1. `agentic/rules_common.md`
2. `agentic/rules_project.md`
3. `agentic/rules_claude.md`
4. `PROJECT_MAP.md`
5. `docs/dev/sessions/current.md`

---

## Session Protocol

### !start

When developer types `!start [goal]`:

1. Read the five files above.
2. Run `git status` and `git log --oneline -5`. Report state as traffic light:
   - 🟢 **Clean** — git clean, session closed → proceed
   - 🟡 **Attention** — uncommitted changes, session closed → ask: incorporate or set aside?
   - 🔴 **Incomplete** — uncommitted changes AND session still open → ask: resume or fresh start?
3. Ask for session goal if not given. Ask for branch:
   - **[N]ew** `session/YYYY-MM-DD-slug` from current
   - **[S]tay** on current branch
   - **[M]ain/master** (default branch)
4. If new branch: `sh scripts/session_start.sh <YYYY-MM-DD-slug>`
5. Write goal + start time to `docs/dev/sessions/current.md`.

### In-Session Freedom (ABW — Always Be Working)

Once `!start` is complete and the session is open:

- **No further confirmations needed** for file edits, terminal commands, or script execution within the repo.
- **Full repo access**: read, edit, grep, diff, create, delete files and folders freely.
- **Tool policies**: set all tools to **Automatic** for the duration of the session.

#### Hard Safety Exceptions (always ask, never auto)

- `git push --force` / `git push --force-with-lease`
- Dropping Qdrant collections (`DELETE /collections/...`)
- `rm -rf` on paths **outside** the repo root
- Committing secrets (`.env`, tokens, credentials, keys)

### !end

When developer types `!end`:

1. Summarize changes (one line).
2. Update `docs/dev/sessions/current.md` (outcome).
3. Append to `docs/dev/sessions/history.md`.
4. Update `PROJECT_MAP.md` if files were added or renamed.
5. Update `docs/dev/open_points.md` and `docs/dev/plans.md` as needed.
6. Run `sh scripts/session_end.sh` (stages all changes — no interactive prompts).
7. **Auto-commit and auto-push** (no confirmation needed on session branches):
   ```
   git commit -m 'session: <agent-composed summary>'
   make session-merge
   git push
   ```
   `make session-merge` squash-merges to main and auto-commits with the same message — one commit on main, no duplicate.

---

## Rules

- **Session gate:** `!start [goal]` required before any work. Read-only questions may proceed without a session.
- **In-session:** ABW mode — no confirmations, full repo access, tools set to Automatic.
- **Hard Safety Exceptions:** always ask (force push, drop collections, rm -rf outside repo, committing secrets).
- Keep files short — split when >150 lines.
- No features beyond the session goal.
