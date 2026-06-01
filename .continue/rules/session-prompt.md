---
alwaysApply: true
---
## Triggers
`!start [goal]` → handshake | `!end` → state sync | `!echo` → repeat last request verbatim

## !start Handshake
1. `git status` + read `docs/dev/sessions/current.md`
2. 🟢 clean+closed→proceed | 🟡 dirty+closed→ask | 🔴 dirty+open→ask
3. Read: current.md → PROJECT_MAP.md → rules_common.md → rules_project.md → README.md + `git log --oneline -5`
4. Ask: [N]ew `session/YYYY-MM-DD-slug` | [S]tay | [M]ain
5. Write goal+time to current.md → enter ABW mode

## ABW Mode
No confirmations for edits/commands/scripts. Full repo access.
**Never auto:** force-push · drop Qdrant collections · `rm -rf` outside repo · commit secrets

## !end State Sync
1. Update current.md + append history.md + update PROJECT_MAP.md + open_points.md + plans.md
2. `sh scripts/session_end.sh`
3. `git commit -m 'session: <summary>' && make session-merge && git push`
