#!/bin/bash
# =============================================================
# Context Kit — Hook Logger
# Called by all hooks to write formatted console output + log file
# Usage: logger.sh <event> <emoji> <message> [detail]
# =============================================================

EVENT="${1:-UNKNOWN}"
EMOJI="${2:-•}"
MESSAGE="${3:-}"
DETAIL="${4:-}"

# Colours (safe for most terminals)
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
MAGENTA="\033[35m"
RED="\033[31m"
BLUE="\033[34m"
WHITE="\033[37m"

# Pick colour by event type
case "$EVENT" in
  SESSION_START)   COLOR=$CYAN ;;
  SESSION_END)     COLOR=$DIM ;;
  AGENT_START)     COLOR=$GREEN ;;
  AGENT_STOP)      COLOR=$BLUE ;;
  TOOL_START)      COLOR=$YELLOW ;;
  TOOL_END)        COLOR=$WHITE ;;
  TOOL_FAIL)       COLOR=$RED ;;
  SCOPE_CHECK)     COLOR=$MAGENTA ;;
  *)               COLOR=$WHITE ;;
esac

TIMESTAMP=$(date "+%H:%M:%S")
LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/session-$(date +%Y-%m-%d).log"

# — Console output —
if [ -n "$DETAIL" ]; then
  printf "${DIM}[%s]${RESET} ${COLOR}${BOLD}%s %s${RESET} ${DIM}%s${RESET}\n" \
    "$TIMESTAMP" "$EMOJI" "$MESSAGE" "$DETAIL" >&2
else
  printf "${DIM}[%s]${RESET} ${COLOR}${BOLD}%s %s${RESET}\n" \
    "$TIMESTAMP" "$EMOJI" "$MESSAGE" >&2
fi

# — File log (plain text, no colour codes) —
mkdir -p "$LOG_DIR"
if [ -n "$DETAIL" ]; then
  echo "[$TIMESTAMP] [$EVENT] $MESSAGE | $DETAIL" >> "$LOG_FILE"
else
  echo "[$TIMESTAMP] [$EVENT] $MESSAGE" >> "$LOG_FILE"
fi
