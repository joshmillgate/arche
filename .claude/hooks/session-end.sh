#!/bin/bash
# =============================================================
# Context Kit — Session End Hook
# Fires when the Claude Code session ends
# =============================================================

INPUT=$(cat)

SESSION_ID=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('session_id','unknown')[:8])" 2>/dev/null || echo "unknown")

HOOKS_DIR="$(dirname "$0")"
LOG_FILE="$HOOKS_DIR/../logs/session-$(date +%Y-%m-%d).log"

# Count agents and tools used this session
AGENT_COUNT=0
TOOL_COUNT=0
if [ -f "$LOG_FILE" ]; then
  AGENT_COUNT=$(grep -c "\[AGENT_START\]" "$LOG_FILE" 2>/dev/null || echo 0)
  TOOL_COUNT=$(grep -c "\[TOOL_START\]" "$LOG_FILE" 2>/dev/null || echo 0)
fi

printf "\n\033[2m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n" >&2
printf "\033[2m  Session ended  %s\033[0m\n" "$SESSION_ID" >&2
if [ "$AGENT_COUNT" -gt 0 ] || [ "$TOOL_COUNT" -gt 0 ]; then
  printf "\033[2m  Agents run: %s   Tools called: %s\033[0m\n" "$AGENT_COUNT" "$TOOL_COUNT" >&2
fi
printf "\033[2m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n\n" >&2

"$HOOKS_DIR/logger.sh" SESSION_END "■" "Session ended" "id=$SESSION_ID agents=$AGENT_COUNT tools=$TOOL_COUNT"

exit 0
