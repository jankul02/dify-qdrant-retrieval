# Dev Howtos

## Start a session (Claude Code)

```
!start add user authentication
```

Agent will report state, ask for branch decision, then you work.

## End a session

```
!end
```

Agent summarizes, updates docs, commits.

## Start a session (Continue)

Context is loaded automatically via `.continue/config.yaml`.  
Type `!start [goal]` in chat.  
Run git ops in terminal: `sh scripts/session_start.sh YYYY-MM-DD-slug`

## Create a new session branch manually

```bash
sh scripts/session_start.sh 2026-05-29-my-feature
```

## Refresh symbol index after refactoring

```bash
make map
```

## Update project from a newer preset version

```bash
copier update
```
Review the diff before accepting changes.
