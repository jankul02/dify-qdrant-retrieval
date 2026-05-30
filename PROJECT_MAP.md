# Project Map — Dify Qdrant Retrieval Plugin

Spatial index: functional area → files. Update at every `!end`.

## Core (root)
- `main.py` — Dify SDK entry point; registers the endpoint group
- `endpoints/qdrant-retrieval.py` — `QdrantRetrievalEndpoint`: embed → search → format (no content filter — pure interface)
- `endpoints/qdrant-upsert.py` — `QdrantUpsertEndpoint`: embed → upsert points into Qdrant; supports single-doc and batch payloads

## Plugin config (root)
- `manifest.yaml` — plugin metadata, permissions, runner config (Python 3.12, amd64/arm64)
- `group/qdrant-retrieval.yaml` — endpoint group definition + 5 settings (Qdrant, Ollama, collection, model); registers both `/retrieval` and `/upsert`
- `requirements.txt` — runtime dependencies
- `.difyignore` — excludes dev-only files from `make pack` output

## Assets
- `_assets/` — plugin icons (icon.svg, icon-dark.svg)

## Docs (upstream / Dify)
- `GUIDE.md` — Dify plugin development reference
- `PRIVACY.md` — marketplace privacy policy

## Dev support (preset)
- `agentic/` — agent rules for Claude Code and Continue; ABW (Always Be Working) mode enabled inside sessions
- `.continue/agents/project.yaml` — named Continue profile ("Dify Qdrant Retrieval Plugin"); activate in VS Code → Continue profile selector
- `.continue/rules/` — Continue-loaded rules: `session-prompt.md` (ABW + auto-commit), `preferterminalforconfig.md`, `nomarkdownintools.md`, `surgical-python-edits.md`, `project-quickref.md`
- `.continue/config.yaml` — documentation/legacy reference only (not loaded by Continue)
- `docs/dev/` — session state, open points, plans, setup, howtos
- `scripts/` — session_start.sh, session_end.sh, bootstrap.sh
- `Makefile` — self-contained targets: `make dev` creates `.venv` + installs deps + downloads dify-plugin CLI; `make pack` builds `.difypkg`
