# High Level Design — Dify Qdrant Retrieval Plugin

## Architecture

```
Dify (chatflow / workflow)
  │  POST /retrieval  {query, retrieval_setting}
  ▼
Plugin endpoint  (QdrantRetrievalEndpoint)
  │
  ├─▶ Ollama  POST /api/embed        → float[] vector
  │          model: nomic-embed-text
  │
  └─▶ Qdrant  POST /points/search    → hits[]
             collection: pdf_pages_vision
             top_k * 10, score_threshold
  │
  ├─ junk filter (_is_junk)          drops blank / repetitive pages
  ├─ metadata enrichment             adds Confluence URL if space_key present
  └─▶ Response  {records[]}
```

## Components

| Component | Role |
|-----------|------|
| `QdrantRetrievalEndpoint` | Handles the HTTP request lifecycle |
| `embed()` | Calls Ollama embed API, returns vector |
| `search()` | Calls Qdrant search API, returns raw hits |
| `_is_junk()` | Filters short, blank, or repetitive content |

## Key design decisions

- Over-fetch (`top_k * 10`, min 50) then filter — junk pages are common in scanned PDFs
- Metadata enrichment happens in the plugin, not in Qdrant payload — keeps payload schema stable
- All service URLs and collection name are currently hardcoded constants — parameterise via `settings` when needed

## References

- [Project Map](PROJECT_MAP.md)
- [Dify External Knowledge Base API spec](https://docs.dify.ai/guides/knowledge-base/external-knowledge-api-documentation)
