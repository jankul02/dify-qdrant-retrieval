# Operational Notes

## Plugin configuration (Dify settings)

When installing or connecting the plugin in Dify, fill in these settings:

| Setting | Default | Description |
|---|---|---|
| Qdrant URL | `http://host.docker.internal:6334` | Qdrant REST endpoint |
| Qdrant API Key | `difyai123456` | Qdrant API key |
| Collection Name | `pdf_pages_vision` | Qdrant collection to search |
| Ollama URL | `http://host.docker.internal:11434` | Ollama embedding service |
| Embedding Model | `nomic-embed-text` | Model name served by Ollama |

### host.docker.internal

`host.docker.internal` resolves to the Docker host from inside a container — use it when Qdrant or Ollama run on the same machine as Dify (Docker Desktop on Mac/Windows handles this automatically; on Linux add `--add-host=host.docker.internal:host-gateway` to the container).
