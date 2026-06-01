#!/usr/bin/env sh
# Inject standard dev-environment lines into a repo's config files if missing.
# Safe to run multiple times — skips lines that are already present.
#
# Targets:
#   .devcontainer/devcontainer.json  — adds ~/.claude bind-mount
#   .continue/agents/sandbox.yaml   — expands ALLOW_COMMANDS for editing

set -e

REPO="${1:-.}"
DC="$REPO/.devcontainer/devcontainer.json"
SB="$REPO/.continue/agents/sandbox.yaml"

CLAUDE_MOUNT='     "source=${localEnv:HOME}/.claude,target=/home/vscode/.claude,type=bind,consistency=cached"'

ALLOW_COMMANDS='sed,awk,head,tail,wc,cut,tr,sort,uniq,diff,patch,cp,mv,mkdir,rm,touch,echo,tee,xargs,jq,curl'

# ── devcontainer.json ─────────────────────────────────────────────────────────

if [ ! -f "$DC" ]; then
  echo "skip  $DC (not found)"
else
  if grep -q '\.claude' "$DC"; then
    echo "ok    $DC (~/.claude mount already present)"
  else
    # Inject after the last existing "mounts" entry (line ending with type=bind...)
    # Works for both single-entry and multi-entry mounts arrays.
    sed -i.bak '/type=bind/ { /\.claude/! s/\(.*\)/\1,\n'"$CLAUDE_MOUNT"'/ }' "$DC"
    rm -f "$DC.bak"
    echo "done  $DC (added ~/.claude mount)"
  fi
fi

# ── sandbox.yaml ALLOW_COMMANDS ───────────────────────────────────────────────

if [ ! -f "$SB" ]; then
  echo "skip  $SB (not found)"
else
  # Check if the editing commands are already present (sed is a reliable marker)
  if grep -q 'sed' "$SB"; then
    echo "ok    $SB (ALLOW_COMMANDS already expanded)"
  else
    # Append the extra commands to the existing ALLOW_COMMANDS value
    sed -i.bak "/ALLOW_COMMANDS:/ s/\"$/,$ALLOW_COMMANDS\"/" "$SB"
    rm -f "$SB.bak"
    echo "done  $SB (expanded ALLOW_COMMANDS)"
  fi
fi
