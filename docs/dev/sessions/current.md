# Current Session

**Status:** Closed

<!-- This file is overwritten at each !start. -->

| Field | Value |
|-------|-------|
| Branch | session/2026-05-30-upsert-auto-create |
| Goal | Auto-create Qdrant collection on upsert if it doesn't exist |
| Started | 2026-05-30 |
| Outcome | Done — `create_collection` added to `qdrant-upsert.py`; on 404 from Qdrant, collection is created (Cosine, vector size inferred from first embedding) and upsert retried; Qdrant 4xx errors now returned as HTTP 400 instead of 500; `docs/dev/howtos.md` updated |
