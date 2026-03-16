#!/bin/bash
# =============================================================
# Context Kit — Opus Confirmation Gate
# Fires on PreToolUse when Claude tries to dispatch the Task tool.
# If the task targets deep-solver (Opus), intercepts and warns the user.
#
# Exit codes:
#   0 = allow (user confirmed, or not an Opus agent call)
#   2 = block (no confirmation, Claude will see the warning message)
# =============================================================

INPUT=$(cat)

# Only care about Task tool calls (how agents are dispatched)
TOOL=$(echo "$INPUT" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('tool_name', ''))
" 2>/dev/null)

if [ "$TOOL" != "Task" ]; then
  exit 0
fi

# Check if this Task is targeting deep-solver
AGENT=$(echo "$INPUT" | python3 -c "
import sys, json
d = json.load(sys.stdin)
inp = d.get('tool_input', {})
# Agent name can appear in description or agent field
description = str(inp.get('description', '')).lower()
agent = str(inp.get('agent', '')).lower()
prompt = str(inp.get('prompt', '')).lower()
combined = description + ' ' + agent + ' ' + prompt
if 'deep-solver' in combined or 'deep_solver' in combined:
    print('yes')
else:
    print('no')
" 2>/dev/null)

if [ "$AGENT" != "yes" ]; then
  exit 0
fi

# ── It IS a deep-solver dispatch. Check for confirmation. ──

HOOKS_DIR="$(dirname "$0")"

# Check if user has confirmed in this session
CONFIRM_FILE="/tmp/context-kit-opus-confirmed-$$"
SESSION_CONFIRM="/tmp/context-kit-opus-session-${PPID}"

if [ -f "$SESSION_CONFIRM" ]; then
  # Already confirmed this session — log and allow
  "$HOOKS_DIR/logger.sh" AGENT_START "🔴" "deep-solver (Opus) dispatched" "user confirmed this session"
  printf "\033[33m\033[1m  ⚠ deep-solver running on Opus\033[0m\033[2m  (confirmed — 3-5x token cost active)\033[0m\n" >&2
  exit 0
fi

# ── No confirmation yet — block and warn ──

# Print warning to stderr (shown to user in Claude Code)
printf "\n" >&2
printf "\033[33m\033[1m┌─────────────────────────────────────────────────┐\033[0m\n" >&2
printf "\033[33m\033[1m│  ⚠️  Opus Agent — Token Cost Warning             │\033[0m\n" >&2
printf "\033[33m\033[1m└─────────────────────────────────────────────────┘\033[0m\n" >&2
printf "\n" >&2
printf "\033[1m  Claude wants to invoke the deep-solver agent.\033[0m\n" >&2
printf "\033[2m  This uses Claude Opus, which costs 3–5× more tokens\033[0m\n" >&2
printf "\033[2m  than Sonnet and will burn your Pro quota faster.\033[0m\n" >&2
printf "\n" >&2
printf "\033[2m  Opus is worth it for:\033[0m\n" >&2
printf "\033[2m    • Bugs that span many files with unknown root cause\033[0m\n" >&2
printf "\033[2m    • Architecture decisions that are hard to undo\033[0m\n" >&2
printf "\033[2m    • Problems where Sonnet has already failed\033[0m\n" >&2
printf "\n" >&2
printf "\033[2m  Sonnet is probably fine for:\033[0m\n" >&2
printf "\033[2m    • Anything with a clear spec\033[0m\n" >&2
printf "\033[2m    • Tasks Sonnet hasn't attempted yet\033[0m\n" >&2
printf "\033[2m    • Routine features and bug fixes\033[0m\n" >&2
printf "\n" >&2
printf "\033[1m  To confirm: reply with \"yes use opus\" or \"confirm deep-solver\"\033[0m\n" >&2
printf "\033[1m  To cancel:  reply with \"no\" or \"use sonnet instead\"\033[0m\n" >&2
printf "\n" >&2

# Log the blocked attempt
"$HOOKS_DIR/logger.sh" AGENT_START "⚠" "deep-solver blocked — awaiting user confirmation" "opus=3-5x token cost"

# Return a message to Claude explaining why it was blocked
# Claude will surface this to the user and wait for their input
cat << 'CLAUDE_MSG'
{"decision": "block", "reason": "I was about to invoke the deep-solver agent which runs on Claude Opus (3–5× the token cost of Sonnet). I've paused to check with you first.\n\nShould I proceed with Opus (deep-solver), or would you like me to attempt this with Sonnet first?\n\nReply 'yes use opus' to confirm, or 'use sonnet' to try the cheaper option first."}
CLAUDE_MSG

exit 2
