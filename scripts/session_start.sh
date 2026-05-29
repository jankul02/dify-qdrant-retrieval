#!/usr/bin/env sh
# Usage: sh scripts/session_start.sh YYYY-MM-DD-short-slug
set -e
SLUG="${1:?Usage: sh scripts/session_start.sh YYYY-MM-DD-short-slug}"
BRANCH="session/$SLUG"
git checkout -b "$BRANCH"
echo "Switched to branch: $BRANCH"
