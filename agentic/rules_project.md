# Project Rules: Dify Qdrant Retrieval Plugin

**Description:** Dify plugin for Qdrant vector search (External Knowledge Base)  
**Stack:** Python 3.12, macOS / Ubuntu

## Layout
- Source: project root (Dify plugin layout — no `src/`)
- Entry point: `main.py`, endpoint: `endpoints/qdrant-retrieval.py`
- Tests: `tests/`
- Deps: `requirements.txt` (runtime), `ruff` (dev linting)
- Config: `.env` (gitignored) — see `.env.example` for all vars

## Conventions
- All service URLs/keys are constants in the endpoint file — parameterise via Dify `settings` when needed
- No Docker in this repo — Qdrant and Ollama run externally

## Project-specific constraints
<!-- Add constraints, known gotchas, and architectural rules here as the project evolves -->
