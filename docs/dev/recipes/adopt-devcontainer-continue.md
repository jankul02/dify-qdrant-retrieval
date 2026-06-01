# Recipe: Adopt Devcontainer + Continue Setup in a New Repo

**Who runs this:** Claude, on the host, inside the target repo.  
**Source repo:** `dify-qdrant-retrieval-plugin` (path known at run time).  
**Target repo:** current working directory.

---

## 0. Variables to resolve before starting

Ask the user for:
- `SOURCE` — absolute path to the source repo (default: `~/projects/dify-qdrant-retrieval-plugin`)
- `PROFILE_NAME` — human-readable profile name for Continue (e.g. `"My Project"`)
- `POST_CREATE` — postCreateCommand for this repo (e.g. `pip install -r requirements.txt`, `npm install`, etc.)

---

## 1. Copy devcontainer

```sh
cp -r $SOURCE/.devcontainer .devcontainer
```

Edit `.devcontainer/devcontainer.json`:
- Replace `postCreateCommand` with `POST_CREATE`
- Keep the `~/.claude` mount line unchanged
- Keep the Ollama logs mount (remove if host doesn't have `~/.ollama/logs`)

Edit `.devcontainer/Dockerfile`:
- Review installed tools — remove `aider-chat` if not needed
- Keep: `git curl ca-certificates gnupg nodejs npm claude-code uv mcp-shell-server`

---

## 2. Copy Continue rules (portable as-is)

```sh
mkdir -p .continue/rules
cp $SOURCE/.continue/rules/nomarkdownintools.md      .continue/rules/
cp $SOURCE/.continue/rules/preferterminalforconfig.md .continue/rules/
cp $SOURCE/.continue/rules/surgical-python-edits.md  .continue/rules/
cp $SOURCE/.continue/rules/project-quickref.md       .continue/rules/
```

Edit `.continue/rules/project-quickref.md` — replace all content with this repo's stack, key paths, and dev commands. Keep `alwaysApply: false`.

---

## 3. Copy and adapt Continue agent profiles

```sh
mkdir -p .continue/agents
cp $SOURCE/.continue/agents/project.yaml .continue/agents/project.yaml
cp $SOURCE/.continue/agents/sandbox.yaml .continue/agents/sandbox.yaml
```

In both files replace:
- Profile `name:` → `PROFILE_NAME`
- `name: "Dify Qdrant Retrieval Plugin (sandbox)"` in sandbox.yaml → `"PROFILE_NAME (sandbox)"`

---

## 4. Copy session protocol rule

```sh
cp $SOURCE/.continue/rules/session-prompt.md .continue/rules/session-prompt.md
```

The session-prompt.md is generic **except** it references these paths:
- `docs/dev/sessions/current.md`
- `PROJECT_MAP.md`
- `agentic/rules_common.md`
- `agentic/rules_project.md`
- `README.md`

If the target repo uses different paths, edit the `!start Handshake` read list in `session-prompt.md`.  
If the repo has no `agentic/` folder, remove those two lines from the read list.

---

## 5. Create minimal session scaffolding (if missing)

Only create what doesn't exist:

```sh
mkdir -p docs/dev/sessions agentic

# current.md — blank session state
cat > docs/dev/sessions/current.md << 'EOF'
# Current Session
Status: closed
EOF

# history.md
touch docs/dev/sessions/history.md

# rules_common.md and rules_project.md — placeholders
touch agentic/rules_common.md
touch agentic/rules_project.md
```

---

## 6. Copy inject script + run it

```sh
mkdir -p scripts
cp $SOURCE/scripts/inject_devcontainer.sh scripts/inject_devcontainer.sh
chmod +x scripts/inject_devcontainer.sh
sh scripts/inject_devcontainer.sh .
```

Expected output: both files report `ok` (just copied, already correct).

---

## 7. Add `make inject` target (if repo has a Makefile)

If the repo has a Makefile, add:

```makefile
inject: ## Inject ~/.claude mount + expanded ALLOW_COMMANDS into a repo (REPO=path, default: .)
	@sh scripts/inject_devcontainer.sh $(REPO)
```

Also add `mcp-shell-server` to the pip install line in `make dev` if present.

---

## 8. Verify

```sh
grep '\.claude' .devcontainer/devcontainer.json   # mount present
grep 'sed' .continue/agents/sandbox.yaml           # ALLOW_COMMANDS expanded
grep 'mcp-shell-server' .devcontainer/Dockerfile   # tool in image
which mcp-shell-server                             # on host PATH (needed by Continue)
```

If `which mcp-shell-server` fails, install it on host PATH:
```sh
pip install --user mcp-shell-server
```
`make dev` does this automatically after the first run.

---

## 9. Commit

```sh
git add .devcontainer .continue docs/dev/sessions agentic scripts
git commit -m 'chore: adopt devcontainer + Continue setup'
```

---

## What is NOT copied

| Item | Reason |
|---|---|
| `PROJECT_MAP.md` | Repo-specific |
| `agentic/rules_project.md` | Repo-specific |
| `scripts/session_start.sh`, `session_end.sh` | Copy only if repo uses session protocol |
| `Makefile` targets beyond `inject` | Repo-specific |
| `.env`, `requirements.txt` | Repo-specific |
