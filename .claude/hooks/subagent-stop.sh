#!/bin/bash
# =============================================================
# Context Kit — Subagent Stop Hook
# Fires when a subagent finishes its work
# =============================================================

INPUT=$(cat)

AGENT_NAME=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('agent_name', d.get('name','unknown')))" 2>/dev/null || echo "unknown")
MODEL=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('model','unknown'))" 2>/dev/null || echo "unknown")

HOOKS_DIR="$(dirname "$0")"

printf "\033[34m\033[1m  ◇ Agent complete\033[0m  \033[1m%s\033[0m\033[2m  on %s\033[0m\n" \
  "$AGENT_NAME" "$MODEL" >&2

"$HOOKS_DIR/logger.sh" AGENT_STOP "◇" "Agent complete: $AGENT_NAME" "model=$MODEL"

exit 0
