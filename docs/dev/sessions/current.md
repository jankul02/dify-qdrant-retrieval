# Current Session

**Status:** Closed

<!-- This file is overwritten at each !start. -->

| Field | Value |
|-------|-------|
| Branch | session/2026-05-30-qdrant-upsert |
| Goal | Design, plan and add an upsert interface to be easily used in Dify |
| Started | 2026-05-30 |
| Outcome | Done — `POST /upsert` endpoint added (`endpoints/qdrant-upsert.py` + `endpoints/qdrant-upsert.yaml`); registered in `group/qdrant-retrieval.yaml`; supports single-doc and batch payloads, deterministic UUID5 for idempotent upsert when `id` provided, `collection` body field overrides settings; usage examples added to `docs/dev/howtos.md`; `PROJECT_MAP.md` updated |
