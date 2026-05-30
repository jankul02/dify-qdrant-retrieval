#!/usr/bin/env sh
# Stage ALL session changes at !end. No interactive prompts — commit manually.
set -e

git add -u

echo "--- Staged ---"
git status --short
echo ""
echo "Next:"
echo "  git commit -m 'session: <summary>'"
echo "  make session-merge"
echo "  git push"
