# Session History

<!-- Append-only. Each entry added by agent at !end. -->

---

## 2026-05-29 — dify-settings-params

| Field | Value |
|-------|-------|
| Branch | session/2026-05-29-dify-settings-params |
| Goal | Generalize Dify settings: move QDRANT_URL, QDRANT_API_KEY, COLLECTION, OLLAMA_URL, EMBED_MODEL from shell/env vars to Dify plugin `settings` parameters |
| Outcome | Done — 5 module-level constants removed from endpoint; settings declared in group YAML with defaults; usage documented in docs/usage/ops.md |

---
