# Common Agent Rules

## Response style
- Concise — no padding, no trailing summaries of what you just did.
- One sentence per status update. Match length to task complexity.

## Code
- Edit existing files; create new ones only when needed.
- No comments unless the WHY is non-obvious.
- No features beyond what is asked.
- Every logic change must be immediately reflected in the relevant doc (doc-sync).

## Safety

### Outside a session (before `!start`)
- `git commit`, `git push`, `sh scripts/*` — always confirm with developer before running.
- File edits — state the file and the change before applying; the tool permission prompt is the confirmation, do not ask twice.
- Deleting files, force push, dropping data — confirm explicitly.
- When scope is unclear: ask, don't assume.
- Never commit secrets (`.env`, tokens, credentials).

### Inside a session (after `!start` — ABW mode)
- **No confirmations needed** for file edits, terminal commands, or script execution within the repo.
- **Full repo access**: read, edit, grep, diff, create, delete files and folders freely.
- **Tool policies**: set all tools to **Automatic**.

### Hard Safety Exceptions (always ask, never auto — even inside a session)
- `git push --force` / `git push --force-with-lease`
- Dropping Qdrant collections (`DELETE /collections/...`)
- `rm -rf` on paths **outside** the repo root
- Committing secrets (`.env`, tokens, credentials, keys)

## Navigation (large codebases)
- Check `PROJECT_MAP.md` and `.tags` (symbol index) before opening files.
- Read only the lines you need, not the whole file.
