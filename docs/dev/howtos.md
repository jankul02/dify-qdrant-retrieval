# Dev Howtos

## Start a session (Claude Code)

```
!start add user authentication
```

Agent will report state, ask for branch decision, then you work.

## End a session

```
!end
```

Agent summarizes, updates docs, commits.

## Start a session (Continue)

1. In VS Code → Continue, select **"Dify Qdrant Retrieval Plugin"** in the profile selector (above the chat box) — this loads `.continue/agents/project.yaml`.
2. Type `!start [goal]` in chat.
3. Run git ops in terminal: `sh scripts/session_start.sh YYYY-MM-DD-slug`

## Configure Dify External Knowledge Base

### Plugin endpoint settings (e.g. `brpserarch`)

| Setting | Example value |
|---------|--------------|
| Qdrant URL | `http://host.docker.internal:6334` |
| Qdrant API Key | your key (default dev: `difyai123456`) |
| Collection Name | `pdf_pages_vision` (fallback when `knowledge_id` not set) |
| Ollama URL | `http://host.docker.internal:11434` |
| Embedding Model | `nomic-embed-text:latest` |

### External Knowledge API settings

| Field | Correct value | Common mistake |
|-------|---------------|----------------|
| API Endpoint | `http://nginx/e/<endpoint-id>` | ~~`http://localhost/...`~~ — fails inside Docker |
| API Endpoint | no `/retrieval` suffix | ~~`.../retrieval`~~ — Dify appends it; `/retrieval/retrieval` → 404 |

Example: `http://nginx/e/d3eamsl50cedociv`

### External Knowledge (knowledge base) settings

| Field | Correct value |
|-------|---------------|
| External Knowledge ID | Qdrant collection name, e.g. `pdf_pages_vision` |
| Top K | 4 |
| Score Threshold | disabled → plugin default `0.3` applies |

> **Why `localhost` fails:** Dify's API container calls the External Knowledge API from inside Docker. `localhost` = the container itself (nothing listening on port 80 → connection refused → "Reached maximum retries (3)"). Use the `nginx` service name instead.

---

## Call the upsert endpoint from a Dify workflow

In a Dify HTTP request node, send `POST` to the plugin's `/upsert` path.

**Single document:**
```json
{
  "id": "doc-abc",
  "content": "The text to embed and store.",
  "metadata": { "title": "My Doc", "source": "https://..." },
  "collection": "my-collection"
}
```

**Batch:**
```json
{
  "collection": "my-collection",
  "documents": [
    { "id": "doc-1", "content": "First chunk.", "metadata": {} },
    { "id": "doc-2", "content": "Second chunk.", "metadata": {} }
  ]
}
```

- `id` is optional; if given, the same `id` always maps to the same Qdrant point (idempotent upsert).
- `collection` overrides the plugin setting — omit it to use the setting default.
- If the collection does not exist it is created automatically (Cosine distance, vector size inferred from the first embedding).
- Response: `{"upserted": 1, "ids": ["doc-abc"], "plugin_version": "0.1.0"}`

## Release a new version

1. During a session, pick a bump type and run:

   ```bash
   make bump-patch   # 0.1.0 → 0.1.1  (bug fixes)
   make bump-minor   # 0.1.0 → 0.2.0  (new features, backwards-compatible)
   make bump-major   # 0.1.0 → 1.0.0  (breaking changes)
   ```

   This will:
   - Update both `version:` fields in `manifest.yaml`
   - Promote `[Unreleased]` → `[X.Y.Z] - YYYY-MM-DD` in `CHANGELOG.md`
   - Git-commit the two files
   - Create and push the `vX.Y.Z` tag to origin

2. Before bumping, add release notes under `## [Unreleased]` in `CHANGELOG.md`.

3. Run `!end` as normal — the session merges to main and pushes the code. The tag is already on origin.

## Create a new session branch manually

```bash
sh scripts/session_start.sh 2026-05-29-my-feature
```

## Refresh symbol index after refactoring

```bash
make map
```

## Update project from a newer preset version

```bash
copier update
```
Review the diff before accepting changes.
