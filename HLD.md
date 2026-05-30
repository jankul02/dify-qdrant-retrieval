# High Level Design — Dify Qdrant Retrieval Plugin

## Architecture

```
Dify (chatflow / workflow)
  │  POST /retrieval  {query, retrieval_setting{top_k, score_threshold}}
  ▼
Plugin endpoint  (QdrantRetrievalEndpoint)
  │
  ├─▶ Ollama  POST /api/embed        → float[] vector
  │          model: nomic-embed-text:latest  (must match index-time model)
  │
  └─▶ Qdrant  POST /points/search    → hits[]
             collection: pdf_pages_vision
             limit: top_k, score_threshold passed through from Dify
  │
  ├─ metadata enrichment             adds Confluence URL if space_key present
  └─▶ Response  {records[]}
```

## Components

| Component | Role |
|-----------|------|
| `QdrantRetrievalEndpoint` | Handles the HTTP request lifecycle |
| `embed()` | Calls Ollama embed API — converts query text to a vector |
| `search()` | Calls Qdrant search API, returns raw hits |

## Key design decisions

- **No content filtering in the plugin.** `top_k` and `score_threshold` come directly from Dify's retrieval settings. Content quality decisions (reranking, length filtering) belong in the Dify workflow, not here.
- **Ollama is the embedding layer only** — no LLM. The model must be identical to the one used when the collection was indexed; a mismatch produces vectors in a different space and silently returns poor results.
- **Dynamic collection via `knowledge_id`**: Dify sends `knowledge_id` in every EKB request. The plugin uses it as the collection name, falling back to the `collection` setting. One plugin instance serves multiple Qdrant collections — each Dify External Knowledge Base just needs a different Knowledge ID.
- **Metadata enrichment** (Confluence URL construction) happens in the plugin to keep the Qdrant payload schema stable.

## References

- [Project Map](PROJECT_MAP.md)
- [Dify External Knowledge Base API spec](https://docs.dify.ai/guides/knowledge-base/external-knowledge-api-documentation)
