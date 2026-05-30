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
