FROM python:3.12-slim

# System deps + Node.js LTS (required by Claude Code CLI)
# Note: lsb-release is required for Docker's apt sources (lsb_release -cs)
RUN apt-get update && apt-get install -y --no-install-recommends \
        git curl ca-certificates gnupg make lsb-release sudo \
     && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
     && apt-get clean && rm -rf /var/lib/apt/lists/*

# Docker CLI + Compose v2 plugin — enables full debugging cycle from inside the devcontainer
# (docker compose up/restart/logs/status/shell into containers)
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
     && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
     && apt-get update \
     && apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin \
     && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir uv mcp-shell-server

# Non-root user matching VS Code Dev Containers convention
RUN groupadd --gid 1000 vscode \
     && useradd --uid 1000 --gid 1000 -m -s /bin/bash vscode

# Add vscode user to docker group for socket access
RUN groupadd -f docker \
     && sh -c 'if getent group 20 >/dev/null; then hostgid20=$(getent group 20 | cut -d: -f1); else groupadd -g 20 hoststaff && hostgid20=hoststaff; fi; \
                if getent group 999 >/dev/null; then hostgid999=$(getent group 999 | cut -d: -f1); else groupadd -g 999 hostdocker && hostgid999=hostdocker; fi; \
                usermod -aG docker,"$hostgid20","$hostgid999",root vscode'
