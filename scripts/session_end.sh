#!/usr/bin/env sh
# Stages session docs and commits. Run after agent updates docs at !end.
set -e
git add docs/dev/sessions/ docs/dev/open_points.md docs/dev/plans.md
echo "--- Staged changes ---"
git status --short
printf "\nCommit message: "
read -r MSG
git commit -m "$MSG"
printf "\nPush to remote? [y/N]: "
read -r PUSH
[ "$PUSH" = "y" ] && git push -u origin "$(git rev-parse --abbrev-ref HEAD)"
echo "Done."
