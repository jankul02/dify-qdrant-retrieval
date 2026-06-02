# Project Map — Dify Qdrant Retrieval Plugin

Spatial index: functional area → files. Update at every `!end`.

## Core (root)
- `main.py` — Dify SDK entry point; registers the endpoint group
- `version.py` — reads `__version__` from `manifest.yaml` at import time; imported by both endpoints
- `endpoints/qdrant-retrieval.py` — `QdrantRetrievalEndpoint`: embed → search → format (no content filter — pure interface); success responses include `plugin_version`
- `endpoints/qdrant-upsert.py` — `QdrantUpsertEndpoint`: embed → upsert points into Qdrant; supports single-doc and batch payloads; success responses include `plugin_version`

## Plugin config (root)
- `manifest.yaml` — plugin metadata, permissions, runner config (Python 3.12, amd64/arm64); single source of truth for version
- `CHANGELOG.md` — Keep-a-Changelog format; updated by `scripts/bump_version.py`
- `group/qdrant-retrieval.yaml` — endpoint group definition + 5 settings (Qdrant, Ollama, collection, model); registers both `/retrieval` and `/upsert`
- `requirements.txt` — runtime dependencies
- `.difyignore` — excludes dev-only files from `make pack` output

## Assets
- `_assets/` — plugin icons (icon.svg, icon-dark.svg)

## Docs (upstream / Dify)
- `GUIDE.md` — Dify plugin development reference
- `PRIVACY.md` — marketplace privacy policy

## Usage docs
- `docs/usage/hacks.md` — workarounds and quick fixes
- `docs/usage/ops.md` — operational notes (Dify settings, connection config)

## Dev docs
- `docs/dev/setup.md` — initial environment setup guide
- `docs/dev/howtos.md` — step-by-step procedures (Dify EKB config, release workflow, upsert usage)
- `docs/dev/open_points.md` — bugs, tech debt, open questions
- `docs/dev/plans.md` — upcoming work and backlog
- `docs/dev/sessions/current.md` — active session state (branch, goal, start time, outcome)
- `docs/dev/sessions/history.md` — append-only session log
- `docs/dev/recipes/adopt-devcontainer-continue.md` — transplant devcontainer + Continue to new repo

## Dev support (preset)
- `.copilot-instructions.md` — VS Code Copilot agent entry point; session protocol (`!start`/`!end`), ABW mode, offline-capable; auto-loaded by Copilot
- `agentic/` — agent rules for Claude Code and Continue; ABW (Always Be Working) mode enabled inside sessions
- `.continue/agents/project.yaml` — named Continue profile ("Dify Qdrant Retrieval Plugin"); activate in VS Code → Continue profile selector
- `.continue/agents/sandbox.yaml` — Continue profile for devcontainer ("…(sandbox)"); routes Ollama via `host.docker.internal:11434`
- `.continue/rules/` — Continue-loaded rules: `session-prompt.md` (ABW + auto-commit), `preferterminalforconfig.md`, `nomarkdownintools.md`, `surgical-python-edits.md`, `project-quickref.md`
- `.continue/config.yaml` — documentation/legacy reference only (not loaded by Continue)
- `scripts/` — session_start.sh, session_end.sh, bootstrap.sh, bump_version.py, inject_devcontainer.sh (injects ~/.claude mount + ALLOW_COMMANDS into any repo)
- `Makefile` — self-contained targets: `make dev` creates `.venv` + installs deps + downloads dify-plugin CLI + mcp-shell-server; `make pack` builds `.difypkg`; `make inject` injects standard devcontainer lines; `make bump-patch/minor/major` bumps version, commits, and pushes tag
