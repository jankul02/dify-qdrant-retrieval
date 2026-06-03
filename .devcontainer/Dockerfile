FROM python:3.12-slim

# System deps + Node.js LTS (required by Claude Code CLI)
RUN apt-get update && apt-get install -y --no-install-recommends \
        git curl ca-certificates gnupg make \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code

# Aider — offline AI pair programmer (connects to Ollama via OLLAMA_API_BASE)
RUN pip install --no-cache-dir aider-chat

# uv + mcp-shell-server — Continue MCP shell tool inside the devcontainer
RUN pip install --no-cache-dir uv mcp-shell-server

# Non-root user matching VS Code Dev Containers convention
RUN groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid 1000 -m -s /bin/bash vscode

WORKDIR /workspace
USER vscode
