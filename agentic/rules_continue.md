# Continue-Specific Rules

Rules and context providers are configured in `.continue/config.yaml`.

## Session start
Type `!start [goal]` in chat. For git ops (branch creation) use the terminal:
```
sh scripts/session_start.sh YYYY-MM-DD-slug
```

## Recommended context to attach manually
- `PROJECT_MAP.md` — for planning or refactoring tasks
- `docs/dev/open_points.md` — for prioritisation discussions
- Relevant source file(s) — Continue does not auto-index everything
