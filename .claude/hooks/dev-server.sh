#!/bin/bash
# =============================================================
# Context Kit — Dev Server Auto-Start Hook
# Fires at SessionStart. If a package.json with a dev script
# exists and no server is already running, starts it silently
# in the background and logs the URL for Claude to report.
# =============================================================

HOOKS_DIR="$(dirname "$0")"
INPUT=$(cat)

# Only run if there's a package.json with a dev script
if [ ! -f "package.json" ]; then
  exit 0
fi

HAS_DEV=$(node -e "const p=require('./package.json'); console.log(p.scripts&&p.scripts.dev?'yes':'no')" 2>/dev/null)
if [ "$HAS_DEV" != "yes" ]; then
  exit 0
fi

# Check if something is already running on common dev ports
for PORT in 3000 3001 4000 4321 5173 8080; do
  if lsof -i ":$PORT" -sTCP:LISTEN -t >/dev/null 2>&1; then
    "$HOOKS_DIR/logger.sh" SESSION_START "✓" "Dev server already running" "port=$PORT"
    # Write the URL to a temp file so Claude can read it
    echo "http://localhost:$PORT" > /tmp/context-kit-dev-url
    exit 0
  fi
done

# No server running — start it in background
"$HOOKS_DIR/logger.sh" SESSION_START "⚡" "Starting dev server..." ""
npm run dev > /tmp/context-kit-dev-log 2>&1 &
DEV_PID=$!
echo $DEV_PID > /tmp/context-kit-dev-pid

# Wait up to 10 seconds for it to bind to a port
for i in $(seq 1 20); do
  sleep 0.5
  for PORT in 3000 3001 4000 4321 5173 8080; do
    if lsof -i ":$PORT" -sTCP:LISTEN -t >/dev/null 2>&1; then
      "$HOOKS_DIR/logger.sh" SESSION_START "✓" "Dev server ready" "http://localhost:$PORT"
      echo "http://localhost:$PORT" > /tmp/context-kit-dev-url
      printf "\033[32m\033[1m  ✓ Dev server running\033[0m\033[2m  http://localhost:%s\033[0m\n" "$PORT" >&2
      exit 0
    fi
  done
done

# Timed out — log it but don't block the session
"$HOOKS_DIR/logger.sh" SESSION_START "⚠" "Dev server did not start in time" "check /tmp/context-kit-dev-log"
exit 0
