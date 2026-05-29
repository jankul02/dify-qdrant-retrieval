# Common Agent Rules

## Response style
- Concise — no padding, no trailing summaries of what you just did.
- One sentence per status update. Match length to task complexity.

## Code
- Edit existing files; create new ones only when needed.
- No comments unless the WHY is non-obvious.
- No features beyond what is asked.
- Every logic change must be immediately reflected in the relevant doc (doc-sync).

## Safety — always ask first
- `git commit`, `git push`, `sh scripts/*` — always confirm with developer before running.
- File edits — state the file and the change before applying; the tool permission prompt is the confirmation, do not ask twice.
- Deleting files, force push, dropping data — confirm explicitly.
- When scope is unclear: ask, don't assume.
- Never commit secrets (`.env`, tokens, credentials).

## Navigation (large codebases)
- Check `PROJECT_MAP.md` and `.tags` (symbol index) before opening files.
- Read only the lines you need, not the whole file.
