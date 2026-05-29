# Dify Qdrant Retrieval Plugin

Dify endpoint plugin — bridges Dify's External Knowledge Base API to a local Qdrant vector store.  
Embeddings via Ollama (`nomic-embed-text`). Junk-filters results before returning.

## Architecture

```
Dify chatflow / workflow
  └─▶ Plugin endpoint (HTTP)
        ├─▶ Ollama  /api/embed      (nomic-embed-text)
        └─▶ Qdrant  /points/search  (pdf_pages_vision)
```

## Documentation

| Doc | Purpose |
|-----|---------|
| [HLD.md](HLD.md) | Architecture and dataflow detail |
| [HANDBOOK.md](HANDBOOK.md) | Installing and using the plugin in Dify |
| [GUIDE.md](GUIDE.md) | Dify plugin development reference (upstream) |
| [docs/dev/setup.md](docs/dev/setup.md) | Dev environment and debug setup |

## Quick start (debug mode)

```bash
cp .env.example .env   # fill in REMOTE_INSTALL_KEY from Dify debug settings
make dev
make run
```
