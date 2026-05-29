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

### !end

When developer types `!end`:

1. Summarize changes. Confirm with developer.
2. Update `docs/dev/sessions/current.md` (outcome).
3. Append to `docs/dev/sessions/history.md`.
4. Update `PROJECT_MAP.md` if files were added or renamed.
5. Update `docs/dev/open_points.md` and `docs/dev/plans.md` as needed.
6. Run `sh scripts/session_end.sh` (stages docs — no interactive prompts).
7. Compose a commit message from the session summary and present the exact commands to run:
   ```
   git commit -m 'session: <agent-composed summary>'
   make session-merge
   git push
   ```
   Developer pastes, reviews, and runs — no writing required.

---

## Rules

- **Always ask before:** `git commit`, `git push`, running any `sh scripts/*`, deleting files, force push.
- **File edits:** state what file you are about to change and why — the tool permission prompt is the confirmation, do not ask twice.
- Keep files short — split when >150 lines.
- No features beyond the session goal.
