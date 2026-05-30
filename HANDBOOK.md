# Handbook — Dify Qdrant Retrieval Plugin

## Install / Update
| Method | When to use |
|---|---|
| **Debug mode** (local dev) | `cp .env.example .env` → `make dev && make run` — plugin registers in Dify via `REMOTE_INSTALL_KEY` |
| **Local file** (production) | `make pack` → upload the `.difypkg` via **Dify → Plugins → Install from local file** |
| **Marketplace** | Search for the plugin in Dify's marketplace (when published) |

To **update**, repeat the same method with the new version in `manifest.yaml`.

> 📖 See [Dify Plugin Installation docs](https://docs.dify.ai/en/develop-plugin/getting-started/plugin-installation) for the full upstream reference.



## Regular usage

<!-- Describe the main usage flows -->

## References

- [Operational notes](docs/usage/ops.md)
- [Hacks and tips](docs/usage/hacks.md)

