# Dev Environment Setup

## Prerequisites

- Python 3.12+
- [uv](https://github.com/astral-sh/uv) (recommended) or pip
- `make` (see bootstrap below)

- VS Code with recommended extensions (see `.vscode/extensions.json`)

## Bootstrap (first time on a new machine)

Ensures `make` is installed:

```bash
sh scripts/bootstrap.sh
```

## First-time setup

```bash
cp .env.example .env
# fill in .env values

uv venv && source .venv/bin/activate
make dev
```



## Common targets

```bash
make help       # list all targets
make dev        # install deps
make check      # lint + test (run before committing)
make map        # regenerate symbol index (.tags) — needs universal-ctags
make cleanup    # remove temp files and caches
make clean      # cleanup + build artifacts
```



## Symbol index (optional, recommended for large codebases)

```bash
brew install universal-ctags   # macOS
sudo apt install universal-ctags  # Ubuntu
make map
```

`.tags` is gitignored. Regenerate after significant refactors.

## How to work with this preset

See [howtos.md](howtos.md) for session workflow and AI agent usage.
