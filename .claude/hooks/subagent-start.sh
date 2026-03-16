#!/bin/bash
# =============================================================
# Context Kit — Subagent Start Hook
# Fires when Claude Code spins up a subagent
# Reads JSON from stdin: { agent_name, model, session_id, ... }
# =============================================================

INPUT=$(cat)

AGENT_NAME=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('agent_name', d.get('name','unknown')))" 2>/dev/null || echo "unknown")
MODEL=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('model','unknown'))" 2>/dev/null || echo "unknown")
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('session_id','unknown')[:8])" 2>/dev/null || echo "unknown")

HOOKS_DIR="$(dirname "$0")"

# Map agent names to friendly descriptions
case "$AGENT_NAME" in
  scope-checker)    DESC="checking request against project scope" ;;
  feature-planner)  DESC="planning feature spec" ;;
  code-reviewer)    DESC="reviewing code for quality & correctness" ;;
  test-writer)      DESC="writing test coverage" ;;
  context-updater)  DESC="syncing context/ files" ;;
  *)                DESC="running task" ;;
esac

printf "\033[32m\033[1m  ◆ Agent starting\033[0m  \033[1m%s\033[0m\033[2m  on %s  —  %s\033[0m\n" \
  "$AGENT_NAME" "$MODEL" "$DESC" >&2

"$HOOKS_DIR/logger.sh" AGENT_START "◆" "Agent starting: $AGENT_NAME" "model=$MODEL task=$DESC session=$SESSION_ID"

exit 0
