---
alwaysApply: false
---

# Dify Qdrant Retrieval Plugin — Quick Reference

**Stack:** Python 3.12, Dify plugin SDK, Qdrant (vector search), Ollama (embeddings)

## Key paths
- Entry point: `main.py` — registers the endpoint group
- Endpoint logic: `endpoints/qdrant-retrieval.py` — embed → search → format
- Plugin config: `manifest.yaml`, `group/qdrant-retrieval.yaml`
- Settings: `.env` (gitignored) — see `.env.example` for all vars
- Tests: `tests/`

## External services (run outside this repo)
- Qdrant: `http://localhost:6333`
- Ollama: `http://localhost:11434`

## Dev commands
- `make dev` — create `.venv`, install deps, download dify-plugin CLI
- `make pack` — build `.difypkg` for Dify marketplace upload

## Full reference
See `PROJECT_MAP.md`, `HLD.md`, `README.md`.
