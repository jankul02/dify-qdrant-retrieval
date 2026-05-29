# Project Map — Dify Qdrant Retrieval Plugin

Spatial index: functional area → files. Update at every `!end`.

## Core (root)
- `main.py` — Dify SDK entry point; registers the endpoint group
- `endpoints/qdrant-retrieval.py` — `QdrantRetrievalEndpoint`: embed → search → filter → format

## Plugin config (root)
- `manifest.yaml` — plugin metadata, permissions, runner config (Python 3.12, amd64/arm64)
- `group/qdrant-retrieval.yaml` — endpoint group definition
- `requirements.txt` — runtime dependencies

## Assets
- `_assets/` — plugin icons (icon.svg, icon-dark.svg)

## Docs (upstream / Dify)
- `GUIDE.md` — Dify plugin development reference
- `PRIVACY.md` — marketplace privacy policy

## Dev support (preset)
- `agentic/` — agent rules for Claude Code and Continue
- `docs/dev/` — session state, open points, plans, setup, howtos
- `scripts/` — session_start.sh, session_end.sh, bootstrap.sh
- `Makefile` — dev / run / pack / lint / map / cleanup
