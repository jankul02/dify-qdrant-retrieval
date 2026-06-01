# Session History

<!-- Append-only. Each entry added by agent at !end. -->

---

## 2026-05-29 — continue-qwen3

| Field | Value |
|-------|-------|
| Branch | session/2026-05-29-continue-qwen3 |
| Goal | Improve Continue plugin tools and reading prompts for use with Qwen 3.6 |
| Outcome | Done — project `.continue/config.yaml` rewritten (qwen3.6:35b, embed, rerank, docs, inline rules); `agentic/rules_continue.md` updated with session gate + edit tool guidance + file pointer rule; global `~/.continue/config.yaml` fixed (YAML parse error, invalid capabilities removed); `~/.continue/rules/session-prompt.md` created |

---

## 2026-05-30 — session-end flow fix

| Field | Value |
|-------|-------|
| Branch | main (direct) |
| Goal | Fix !end flow so all changes are committed, not just docs |
| Outcome | Done — `session_end.sh` uses `git add -u`; `make session-merge` auto-commits on main with session branch message; no duplicate commit needed |

---

## 2026-05-30 — make-pack + multi-collection

| Field | Value |
|-------|-------|
| Branch | main (direct — continuation after session-merge) |
| Goal | Capture missed code changes + multi-collection support |
| Outcome | Done — `knowledge_id` from Dify EKB protocol used as dynamic collection override (fallback to plugin setting); architecture reviewed: embedding stays in plugin for coherence, Tool endpoint for upsert would take collection as explicit parameter; junk filter confirmed removed (pure interface decision) |

---

## 2026-05-30 — make-pack

| Field | Value |
|-------|-------|
| Branch | session/2026-05-30-make-pack |
| Goal | Get `make pack` working |
| Outcome | Done — Makefile made self-contained (uv venv, uv pip, auto-downloads dify-plugin CLI binary); `.difyignore` updated to exclude dev files; HANDBOOK.md got "How to use in Dify" section; endpoint junk filter removed (plugin is now a pure interface); case-insensitive query extraction added; embed_model default changed to nomic-embed-text:latest; helper text added to all plugin settings; HLD.md updated |

---

## 2026-05-30 — continue-rules-migration

| Field | Value |
|-------|-------|
| Branch | main (direct) |
| Goal | Agentic setup takeover — port Continue rules from testdifyollama |
| Outcome | Done — `.continue/config.yaml` annotated as ignored (Continue only loads global config); `.continue/rules/` created with 5 rule files: `session-prompt.md`, `preferterminalforconfig.md`, `nomarkdownintools.md`, `surgical-python-edits.md`, `project-quickref.md`; `agentic/rules_continue.md` corrected to terminal-only file edits (`cat << EOF`) |

---

## 2026-05-30 — qdrant-upsert

| Field | Value |
|-------|-------|
| Branch | session/2026-05-30-qdrant-upsert |
| Goal | Design, plan and add an upsert interface to be easily used in Dify |
| Outcome | Done — `POST /upsert` endpoint added (`endpoints/qdrant-upsert.py` + `endpoints/qdrant-upsert.yaml`); registered in `group/qdrant-retrieval.yaml`; supports single-doc and batch payloads, deterministic UUID5 for idempotent upsert when `id` provided, `collection` body field overrides settings; usage examples added to `docs/dev/howtos.md`; `PROJECT_MAP.md` updated |

---

## 2026-05-30 — agentic-abw-update

| Field | Value |
|-------|-------|
| Branch | session/2026-05-30-agentic-abw-update |
| Goal | Port ABW mode, auto-commit/push on !end, and Continue agents/project.yaml from testdifyollama last 4 sessions |
| Outcome | Done — ABW mode ported to `agentic/rules_common.md`, `CLAUDE.md`, `.continue/rules/session-prompt.md`, `agentic/rules_continue.md`; `.continue/agents/project.yaml` created (named Continue profile); `.continue/config.yaml` header updated; `docs/dev/howtos.md` stale config reference fixed; `PROJECT_MAP.md` updated |

---

## 2026-05-30 — upsert-auto-create

| Field | Value |
|-------|-------|
| Branch | session/2026-05-30-upsert-auto-create |
| Goal | Auto-create Qdrant collection on upsert if it doesn't exist |
| Outcome | Done — `create_collection` added to `qdrant-upsert.py`; on 404 from Qdrant, collection is created (Cosine, vector size inferred from first embedding) and upsert retried; Qdrant 4xx errors now returned as HTTP 400 instead of 500; `docs/dev/howtos.md` updated |

---

## 2026-06-01 — aider-performance

| Field | Value |
|-------|-------|
| Branch | session/2026-06-01-aider-performance |
| Goal | Improve aider performance — reduce verbosity, make it execute tasks |
| Outcome | Removed — qwen3.6 via Ollama is too verbose and non-compliant for reliable aider use (architect mode loops, thinking can't be suppressed, model ignores instructions); `.aider.conf.yml`, `.aiderignore`, `agentic/rules_aider.md` deleted; `.gitignore` simplified |

---

## 2026-05-31 — devcontainer-sandbox

| Field | Value |
|-------|-------|
| Branch | session/2026-05-31-devcontainer-sandbox |
| Goal | Set up devcontainer sandbox for isolated development; install aider on host |
| Outcome | Done — aider installed on host (pip, 0.86.2); `.aider.conf.yml` updated for host+container use (ollama_chat prefix, Fast-Apply editor, qwen2.5-coder:1.5b weak model); `agentic/rules_aider.md` improved (thinking-mode suppression, /run execution model, session start sequence); devcontainer sandboxing fixed (`--network=host` removed — `--add-host` is sufficient; `nomarkdownintools.md` devcontainer paragraph moved to `sandbox.yaml` rules where it is sandbox-scoped); `.gitignore` aider patterns simplified with allowlist exceptions. Open: `qwen3.6:27b-coding-mxfp8` not in `ollama list` — pull or rename to `qwen3-coder:latest`; `max-tokens` cap removed from aider config |

---

## 2026-05-31 — fix-external-knowledge-connection

| Field | Value |
|-------|-------|
| Branch | main (direct) |
| Goal | Fix External Knowledge connection + document Dify settings |
| Outcome | Done — `pdf_url` field added to retrieval metadata; `page_num` fallback improved (page_start → page_num → 1); Dify connection root causes found: (1) `knowledge_id` sent by Dify is used as Qdrant collection name — must equal collection name in Dify EKB settings; (2) API Endpoint URL must use `http://nginx/e/<id>` not `http://localhost/...` (Docker localhost ≠ nginx); (3) no `/retrieval` suffix in API Endpoint — Dify appends it automatically; howtos.md updated with full Dify EKB configuration reference |

---

## 2026-05-30 — plugin-versioning

| Field | Value |
|-------|-------|
| Branch | session/2026-05-30-plugin-versioning |
| Goal | Plugin versioning |
| Outcome | Done — semver workflow added: `version.py` reads `__version__` from `manifest.yaml`; `scripts/bump_version.py` bumps version, updates CHANGELOG, commits, creates and pushes git tag; `make bump-patch/minor/major` targets added; `CHANGELOG.md` created; `manifest.yaml` bumped to `0.1.0`; both endpoints return `plugin_version` in success responses; `docs/dev/howtos.md` updated with release workflow |

---

## 2026-06-01 — continue-apply-model

| Field | Value |
|-------|-------|
| Branch | main (direct) |
| Goal | Investigate Continue apply-model switching; commit Makefile + recipe changes |
| Outcome | Done — removed MCP file-writing rule from project.yaml (was blocking Continue's native apply flow); committed Makefile host-PATH mcp-shell-server install and adopt recipe PATH check; project.yaml/sandbox.yaml pre-existing tool_use + role cleanup committed |

---

## 2026-06-01 — continue-mcp-shell

| Field | Value |
|-------|-------|
| Branch | session/2026-06-01-continue-mcp-shell |
| Goal | Add mcp-shell-server to devcontainer so Continue can execute shell commands without the VS Code remote terminal problem |
| Outcome | Done — `~/.claude` bind-mount added to devcontainer.json (persists chat history across rebuilds); `mcp-shell-server` added to `make dev` + both Continue profiles; `ALLOW_COMMANDS` expanded with editing commands (sed, awk, patch, cp, mv, etc.); host profile (`project.yaml`) gets MCP shell with conservative command set; nomic-embed-text reranker replaced with bge-reranker in both profiles; `preferterminalforconfig.md` updated to MCP shell (dropped cat<<EOF); all 8 Continue rules compressed; `scripts/inject_devcontainer.sh` + `make inject` added for cross-repo setup; `docs/dev/recipes/adopt-devcontainer-continue.md` recipe written |

---

## 2026-05-29 — dify-settings-params

| Field | Value |
|-------|-------|
| Branch | session/2026-05-29-dify-settings-params |
| Goal | Generalize Dify settings: move QDRANT_URL, QDRANT_API_KEY, COLLECTION, OLLAMA_URL, EMBED_MODEL from shell/env vars to Dify plugin `settings` parameters |
| Outcome | Done — 5 module-level constants removed from endpoint; settings declared in group YAML with defaults; usage documented in docs/usage/ops.md |

---
