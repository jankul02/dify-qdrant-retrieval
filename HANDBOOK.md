# Handbook — Dify Qdrant Retrieval Plugin

## Install / Update
| Method | When to use |
|---|---|
| **Debug mode** (local dev) | `cp .env.example .env` → `make dev && make run` — plugin registers in Dify via `REMOTE_INSTALL_KEY` |
| **Local file** (production) | `make pack` → upload the `.difypkg` via **Dify → Plugins → Install from local file** |
| **Marketplace** | Search for the plugin in Dify's marketplace (when published) |

To **update**, repeat the same method with the new version in `manifest.yaml`.

> 📖 See [Dify Plugin Installation docs](https://docs.dify.ai/en/develop-plugin/getting-started/plugin-installation) for the full upstream reference.



## How to use in Dify

### Prerequisites

- Qdrant running and reachable from Dify (e.g. `http://host.docker.internal:6334`)
- Ollama running with the embedding model pulled (e.g. `nomic-embed-text`)
- Plugin installed (see **Install / Update** above)

### 1 — Configure the plugin endpoint

1. Open Dify → **Plugins** → find **qdrant-retrieval** → click **Settings** (or the endpoint name).
2. Fill in the five settings:

   | Setting | Example |
   |---|---|
   | Qdrant URL | `http://host.docker.internal:6334` |
   | Qdrant API Key | `difyai123456` |
   | Collection Name | `pdf_pages_vision` |
   | Ollama URL | `http://host.docker.internal:11434` |
   | Embedding Model | `nomic-embed-text` |

3. Save. Dify assigns the endpoint a URL — copy it (you'll need it in the next step).

### 2 — Register as External Knowledge Base

1. Open Dify → **Knowledge** → **External Knowledge API** → **Add an External Knowledge API**.
2. Paste the endpoint URL from step 1 into the **API Endpoint** field.
3. Set **API Key** to any static string (the plugin doesn't validate it, but Dify requires one).
4. Click **Save**, then **Create External Knowledge Base** → select the API you just added.
5. Give the knowledge base a name and save.

### 3 — Use in an application

In a **Chatflow** or **Workflow**:

1. Add a **Knowledge Retrieval** node.
2. Select the external knowledge base you created in step 2.
3. Wire the node's output (`result`) into your LLM prompt as context.

The node returns chunks with `content`, `title`, `score`, and rich metadata (Confluence URL, space key, category, folder path) ready for the model to cite.

## References

- [Operational notes](docs/usage/ops.md)
- [Hacks and tips](docs/usage/hacks.md)

