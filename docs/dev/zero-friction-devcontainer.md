# Zero-Friction Devcontainer Setup

**Purpose:** Make agent-assisted coding inside a devcontainer completely hands-off — no permission prompts, no "keep?" dialogs, no interpreter errors.

**Source:** Transplanted from `jankul02/testdifyollama` (session: 2026-06-03 docker-compose-fix).

---

## The Three Files

| File | What it does |
|------|--------------|
| `.vscode/settings.json` | Python interpreter, auto-save, auto-accept — kills all confirmation prompts |
| `.devcontainer/devcontainer.json` | Container definition, extensions, mounts, env vars |
| `.devcontainer/Dockerfile` | Base image, system deps, Python packages, Docker CLI |

---

## Friction Points & Fixes

### 1. Python interpreter not found

**Symptom:** `Default interpreter path '/opt/homebrew/bin/python3' could not be resolved`

**Cause:** VS Code inherits the host's Python path (macOS Homebrew) which doesn't exist in the container.

**Fix:** `.vscode/settings.json` → `"python.defaultInterpreterPath": "python3"`

### 2. "Keep?" prompts on file edits

**Symptom:** VS Code asks whether to keep changes when an agent edits a file.

**Cause:** `files.autoSave` is off or `files.confirmBeforeClose` is true.

**Fix:** `.vscode/settings.json`:
```json
"files.autoSave": "afterDelay",
"files.autoSaveDelay": 1000,
"files.confirmBeforeClose": false,
"files.confirmBeforeSaveExternal": false
```

### 3. Tool acceptance prompts (Bash, Read, Write)

**Symptom:** VS Code prompts "Allow tool: Bash(git status)" or "Allow reading file ...".

**Cause:** VS Code Copilot / Continue extension has manual tool permissions.

**Fix:**
- **VS Code settings:** `"continue.autoAccept": true`
- **Continue config:** In `.continue/agents/sandbox.yaml`, the `mcpServers.shell.env.ALLOW_COMMANDS` lists all permitted shell commands.

### 4. No Docker CLI in container

**Symptom:** `docker: command not found` when running `make up` from inside devcontainer.

**Fix:** Install `docker-ce-cli` + `docker-compose-plugin` in Dockerfile; mount Docker socket in `devcontainer.json`.

---

## Key Differences from Original (testdifyollama)

| Area | testdifyollama | dify-qdrant-retrieval |
|------|----------------|----------------------|
| Extensions | claude-code | ms-azuretools.vscode-cosmosdb |
| Aider | Installed | Not needed |
| Name | document-intelligence-pipeline | dify-qdrant-retrieval |

---

## How to Test

1. Open repo in VS Code → "Reopen in Container"
2. Open a Python file → verify no interpreter error
3. Ask the agent to edit a file → verify no "keep?" prompt
4. Ask the agent to run a shell command → verify no acceptance prompt
5. Run `docker compose version` inside container → verify Docker CLI works
