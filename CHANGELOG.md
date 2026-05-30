# Changelog

All notable changes are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) — [Semver](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-05-30

### Added
- `POST /upsert` endpoint for ingestion from Dify workflows (single-doc and batch, deterministic UUID5 for idempotent upsert, `collection` body field overrides settings)
- Plugin version metadata in all success API responses (`plugin_version` field)
- Semver tooling: `scripts/bump_version.py`, `make bump-patch/minor/major`, `make tag`

## [0.0.1] - 2026-05-11

### Added
- Initial release: `POST /retrieval` endpoint for Qdrant vector search (Dify External Knowledge Base)
- Ollama embedding support
- Multi-collection routing via `knowledge_id`
