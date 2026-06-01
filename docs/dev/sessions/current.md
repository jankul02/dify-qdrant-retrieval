# Current Session

**Status:** Open

<!-- This file is overwritten at each !start. -->

| Field | Value |
|-------|-------|
| Branch | session/2026-06-01-continue-mcp-shell |
| Goal | Add mcp-shell-server to devcontainer so Continue can execute shell commands without the VS Code remote terminal problem |
| Started | 2026-06-01 |
| Outcome | Done |

## Sandbox Setup

The devcontainer was installed via:
```bash
bash ~/projects/dev-sandbox/scripts/install.sh python-agent ~/projects/dify-qdrant-retrieval
```

This created:
- `.devcontainer/devcontainer.json` — container config with Ollama bridge, security hardening (no API key passthrough)
- `.devcontainer/Dockerfile` — Python 3.12-slim + Node.js 22 + Claude Code CLI
- `.continue/agents/sandbox.yaml` — Continue profile "(sandbox)" routing Ollama through `host.docker.internal:11434`

## Claude Code CLI Authentication

No `ANTHROPIC_API_KEY` is forwarded from the host. Instead, authenticate inside the container:

1. Reopen in devcontainer (`Cmd+Shift+P → Dev Containers: Reopen in Container`)
2. Open a terminal inside the container
3. Run `claude login` — follows OAuth flow (browser or code-based)
4. Credentials stored in `~/.claude/` inside the container

## Continue Agents

Two profiles available:
- **`project.yaml`** — "Dify Qdrant Retrieval Plugin" — Ollama on `localhost:11434` (host use)
- **`sandbox.yaml`** — "Dify Qdrant Retrieval Plugin (sandbox)" — Ollama on `host.docker.internal:11434` (container use)

Both are pure Ollama — no Anthropic models configured.

## Activation Steps

1. `git add .devcontainer/ .continue/agents/sandbox.yaml && git commit -m 'add devcontainer sandbox'`
2. Open `dify-qdrant-retrieval` in VS Code
3. `Cmd+Shift+P` → `Dev Containers: Reopen in Container`
4. In container terminal: `claude login`
5. In Continue panel, switch to profile ending with `(sandbox)`
6. On Linux: verify `--add-host=host.docker.internal:host-gateway` in `devcontainer.json` runArgs (already present)
