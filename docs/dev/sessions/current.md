# Current Session

**Status:** Open

<!-- This file is overwritten at each !start. -->

| Field | Value |
|-------|-------|
| Branch | session/2026-05-31-devcontainer-sandbox |
| Goal | Set up devcontainer sandbox for isolated development; document ANTHROPIC_API_KEY export |
| Started | 2026-05-31 |
| Outcome | |

## Sandbox Setup

The devcontainer was installed via:
```bash
bash ~/projects/dev-sandbox/scripts/install.sh python-agent ~/projects/dify-qdrant-retrieval
```

This created:
- `.devcontainer/devcontainer.json` — container config with Ollama bridge, ANTHROPIC_API_KEY passthrough, security hardening
- `.devcontainer/Dockerfile` — Python 3.12-slim + Node.js 22 + Claude Code CLI
- `.continue/agents/sandbox.yaml` — Continue profile "(sandbox)" routing Ollama through `host.docker.internal:11434`

## ANTHROPIC_API_KEY

**Current status:** NOT SET in host shell (`~/.zshrc`, `~/.bashrc`, etc. have no export).

**How the devcontainer handles it:** `devcontainer.json` has `"ANTHROPIC_API_KEY": "${localEnv:ANTHROPIC_API_KEY}"` in `remoteEnv`, which forwards the host env var into the container at startup. If the host var is unset, the container var will also be unset.

**To make it persistent on the host**, add to `~/.zshrc` (or `~/.bashrc`):
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```
Then `source ~/.zshrc` or restart the terminal.

**Alternative (container-only):** Set it in `devcontainer.json` `remoteEnv` directly as a literal string, but this risks committing secrets if the file is tracked. **Not recommended** — use the host env var approach.

## Activation Steps

1. `git add .devcontainer/ .continue/agents/sandbox.yaml && git commit -m 'add devcontainer sandbox'`
2. Open `dify-qdrant-retrieval` in VS Code
3. `Cmd+Shift+P` → `Dev Containers: Reopen in Container`
4. Ensure `ANTHROPIC_API_KEY` is exported in your host shell (see above)
5. In Continue panel, switch to profile ending with `(sandbox)`
6. On Linux: verify `--add-host=host.docker.internal:host-gateway` in `devcontainer.json` runArgs (already present)
