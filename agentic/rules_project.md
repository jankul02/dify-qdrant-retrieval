# Project Rules: Dify Qdrant Retrieval Plugin

**Description:** Dify plugin for Qdrant vector search (External Knowledge Base)  
**Stack:** Python 3.12, Docker, macOS / Ubuntu

## Layout
- Package: `src/qdrant_retrieval/`
- Tests: `tests/` (mirrors src structure)
- Config: `.env` (gitignored) — see `.env.example` for all vars

## Conventions
- One installable package per repo
- All external config via environment variables — no hardcoded values
- Docker Compose for local services; `docker/docker-compose.yml`

## Project-specific constraints
<!-- Add constraints, known gotchas, and architectural rules here as the project evolves -->
