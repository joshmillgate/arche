#!/bin/bash
# =============================================================
# Context Kit — Pre Tool Use Hook
# Fires before Claude uses any tool (Read, Write, Bash, etc.)
# Only logs — never blocks (exit 0 always)
# =============================================================

INPUT=$(cat)

TOOL=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name','unknown'))" 2>/dev/null || echo "unknown")

# Build a short summary of what the tool is doing
SUMMARY=$(echo "$INPUT" | python3 -c "
import sys, json
d = json.load(sys.stdin)
inp = d.get('tool_input', {})
tool = d.get('tool_name', '')

if tool == 'Bash':
    cmd = inp.get('command', '')
    print(cmd[:60] + ('...' if len(cmd) > 60 else ''))
elif tool in ('Write', 'Edit', 'Create'):
    print(inp.get('file_path', inp.get('path', '')))
elif tool == 'Read':
    print(inp.get('file_path', inp.get('path', '')))
elif tool == 'Glob':
    print(inp.get('pattern', ''))
elif tool == 'Grep':
    pattern = inp.get('pattern', '')
    path = inp.get('path', '')
    print(f'{pattern} in {path}' if path else pattern)
else:
    keys = list(inp.keys())
    print(', '.join(keys[:3]) if keys else '')
" 2>/dev/null || echo "")

HOOKS_DIR="$(dirname "$0")"

# Only log tools that are meaningful (skip noisy ones)
case "$TOOL" in
  Read|Write|Edit|Bash|Glob|Grep|Task)
    printf "\033[33m\033[2m    ↳ %s\033[0m\033[2m  %s\033[0m\n" "$TOOL" "$SUMMARY" >&2
    "$HOOKS_DIR/logger.sh" TOOL_START "↳" "Tool: $TOOL" "$SUMMARY"
    ;;
esac

exit 0
