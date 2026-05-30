.DEFAULT_GOAL := help

.PHONY: help dev run pack lint format check map cleanup clean session-merge

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'

# ── Development ───────────────────────────────────────────────────────────────

DIFY_PLUGIN_VERSION := 0.0.6
DIFY_PLUGIN_OS     := $(shell uname -s | tr '[:upper:]' '[:lower:]')
DIFY_PLUGIN_ARCH   := $(shell uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')
DIFY_PLUGIN_BIN    := .venv/bin/dify-plugin
DIFY_PLUGIN_URL    := https://github.com/langgenius/dify-plugin-daemon/releases/download/$(DIFY_PLUGIN_VERSION)/dify-plugin-$(DIFY_PLUGIN_OS)-$(DIFY_PLUGIN_ARCH)

dev: ## Create .venv (if needed), install deps, and fetch dify-plugin CLI
	@echo "→ Setting up environment..."
	@test -d .venv || uv venv
	uv pip install --python .venv/bin/python -r requirements.txt ruff dify-plugin
	@test -x $(DIFY_PLUGIN_BIN) || \
	  (echo "→ Downloading dify-plugin CLI $(DIFY_PLUGIN_VERSION) ($(DIFY_PLUGIN_OS)-$(DIFY_PLUGIN_ARCH))..." && \
	   curl -sL $(DIFY_PLUGIN_URL) -o $(DIFY_PLUGIN_BIN) && chmod +x $(DIFY_PLUGIN_BIN))
	@echo "✓ Done. Run 'make run' to start in debug mode."

run: ## Run plugin in debug mode (requires .env with REMOTE_INSTALL_KEY)
	@echo "→ Starting plugin (debug mode)..."
	.venv/bin/python -m main

# ── Packaging ─────────────────────────────────────────────────────────────────

PLUGIN_NAME := $(shell grep '^name:' manifest.yaml | awk '{print $$2}')

pack: ## Package plugin into .difypkg (run make dev first)
	@test -x $(DIFY_PLUGIN_BIN) || \
	  (echo "✗ dify-plugin not found. Run 'make dev' first."; exit 1)
	@echo "→ Packaging plugin..."
	@cd ..; $(abspath $(DIFY_PLUGIN_BIN)) plugin package $(notdir $(CURDIR)) -o $(CURDIR)/$(PLUGIN_NAME).difypkg
	@echo "✓ Package ready: $(PLUGIN_NAME).difypkg"

# ── Quality ───────────────────────────────────────────────────────────────────

lint: ## Lint with ruff
	@echo "→ Linting..."
	.venv/bin/ruff check endpoints main.py
	@echo "✓ No issues."

format: ## Format with ruff (modifies files)
	@echo "→ Formatting..."
	.venv/bin/ruff format endpoints main.py
	@echo "✓ Formatted."

check: lint ## Run all checks (use before committing)
	@echo "✓ All checks passed."

# ── Navigation ────────────────────────────────────────────────────────────────

map: ## Regenerate symbol index (.tags) — requires universal-ctags
	@command -v ctags >/dev/null 2>&1 || \
	  (echo "✗ ctags not found. Install: brew install universal-ctags"; exit 1)
	@echo "→ Generating symbol index..."
	ctags -R --languages=Python --exclude=.venv --exclude=__pycache__ -f .tags endpoints main.py
	@echo "✓ .tags updated."

# ── Housekeeping ──────────────────────────────────────────────────────────────

cleanup: ## Remove temp files and caches
	@find . -name "*.pyc" -delete 2>/dev/null; true
	@find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null; true
	@echo "✓ Clean."

clean: cleanup ## Remove build artifacts + temp files
	rm -rf dist/ build/
	@echo "✓ Clean."

# ── Session ───────────────────────────────────────────────────────────────────

session-merge: ## Squash-merge session branch into main and commit
	@test -z "$$(git status --porcelain)" || \
	  (echo "✗ Uncommitted changes — run 'git commit' on the session branch first."; exit 1)
	@BRANCH=$$(git rev-parse --abbrev-ref HEAD); \
	MSG=$$(git log --format=%s -1); \
	echo "→ Squash-merging $$BRANCH → main..."; \
	git checkout main && \
	git merge --squash $$BRANCH && \
	git commit -m "$$MSG" && \
	echo "✓ Done. Run: git push"
