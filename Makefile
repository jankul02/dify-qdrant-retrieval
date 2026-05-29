.DEFAULT_GOAL := help

.PHONY: help dev run pack lint format check map cleanup clean session-merge

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'

# ── Development ───────────────────────────────────────────────────────────────

dev: ## Install dependencies (venv must be active)
	@echo "→ Installing dependencies..."
	pip install -r requirements.txt
	pip install ruff
	@echo "✓ Done. Run 'make run' to start in debug mode."

run: ## Run plugin in debug mode (requires .env with REMOTE_INSTALL_KEY)
	@echo "→ Starting plugin (debug mode)..."
	python -m main

# ── Packaging ─────────────────────────────────────────────────────────────────

pack: ## Package plugin into .difypkg (requires dify-plugin CLI)
	@command -v dify-plugin >/dev/null 2>&1 || \
	  (echo "✗ dify-plugin CLI not found. Install: pip install dify-plugin"; exit 1)
	@echo "→ Packaging plugin..."
	dify-plugin plugin package .
	@echo "✓ Package ready. Install via Dify → Plugins → Install from local file."

# ── Quality ───────────────────────────────────────────────────────────────────

lint: ## Lint with ruff
	@echo "→ Linting..."
	ruff check endpoints main.py
	@echo "✓ No issues."

format: ## Format with ruff (modifies files)
	@echo "→ Formatting..."
	ruff format endpoints main.py
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

session-merge: ## Squash-merge current session branch into main, then push
	@BRANCH=$$(git rev-parse --abbrev-ref HEAD); \
	echo "→ Squash-merging $$BRANCH → main..."; \
	git checkout main && \
	git merge --squash $$BRANCH && \
	echo "✓ Changes staged on main." && \
	echo "  Run: git commit -m 'session: <summary>' && git push"
