#!/bin/bash
# =============================================================
# Context Kit — Session Start Hook
# Fires at the beginning of every Claude Code session
# Reads JSON from stdin: { session_id, model, cwd, ... }
# =============================================================

INPUT=$(cat)

SESSION_ID=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('session_id','unknown')[:8])" 2>/dev/null || echo "unknown")
MODEL=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('model','unknown'))" 2>/dev/null || echo "unknown")
CWD=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('cwd',''))" 2>/dev/null || echo "")
PROJECT=$(basename "$CWD")

HOOKS_DIR="$(dirname "$0")"

# Print session banner
printf "\n\033[36m\033[1m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n" >&2
printf "\033[36m\033[1m  🤖 Claude Code Session Started\033[0m\n" >&2
printf "\033[2m  Session : %s\033[0m\n" "$SESSION_ID" >&2
printf "\033[2m  Model   : %s\033[0m\n" "$MODEL" >&2
printf "\033[2m  Project : %s\033[0m\n" "$PROJECT" >&2
printf "\033[2m  Time    : %s\033[0m\n" "$(date '+%A %d %b %Y, %H:%M')" >&2
printf "\033[36m\033[1m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n\n" >&2

# Log it
"$HOOKS_DIR/logger.sh" SESSION_START "🚀" "Session started" "model=$MODEL project=$PROJECT id=$SESSION_ID"

exit 0

# Auto-start dev server if applicable
bash "$(dirname "$0")/dev-server.sh" <<< "$INPUT"

# If a dev URL was found, inject it as context for Claude
if [ -f /tmp/context-kit-dev-url ]; then
  DEV_URL=$(cat /tmp/context-kit-dev-url)
  echo "{\"context\": \"Dev server is running at $DEV_URL\"}"
fi
