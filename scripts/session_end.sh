#!/usr/bin/env sh
# Stage session docs at !end. No interactive prompts — commit and merge manually.
set -e

git add docs/dev/sessions/ docs/dev/open_points.md docs/dev/plans.md PROJECT_MAP.md 2>/dev/null; true

echo "--- Staged ---"
git status --short
echo ""
echo "Next:"
echo "  git commit -m 'session: <summary>'"
echo "  make session-merge     # squash into main and push"
