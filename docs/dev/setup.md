# Dev Environment Setup

## Prerequisites

- Python 3.12+
- [uv](https://github.com/astral-sh/uv) (recommended) or pip
- `make` (see bootstrap below)
- VS Code with recommended extensions (see `.vscode/extensions.json`)

## Bootstrap (first time on a new machine)

```bash
sh scripts/bootstrap.sh   # ensures make is installed
```

## First-time setup

```bash
cp .env.example .env
# fill in REMOTE_INSTALL_KEY from your Dify instance debug settings

uv venv && source .venv/bin/activate
make dev   # installs requirements.txt + ruff
```

## Common targets

```bash
make help       # list all targets
make run        # start plugin in debug mode (requires .env)
make pack       # build .difypkg (requires dify-plugin CLI)
make lint       # ruff check
make map        # regenerate symbol index (.tags) — needs universal-ctags
make cleanup    # remove temp files and caches
```

## Symbol index (optional)

```bash
brew install universal-ctags   # macOS
sudo apt install universal-ctags  # Ubuntu
make map
```

## How to work with this preset

See [howtos.md](howtos.md) for session workflow and AI agent usage.
