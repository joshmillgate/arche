---
description: Sync context/ files to reflect the current state of the codebase. Run this if context feels stale or after a batch of work.
allowed-tools: Read, Write, Glob, Bash(git log:*)
disable-model-invocation: true
---

Dispatch context-updater to review the current codebase and bring all context/ files up to date.

Before dispatching, give the context-updater a useful summary to work from:

1. Run !`git log --oneline -20` to see recent commits
2. Run !`git diff HEAD~5 --name-only` to see recently changed files
3. Scan context/features/ for any features with stale statuses

Pass this summary to context-updater so it knows what areas to focus on.

After context-updater completes, report briefly:
- Which files were updated
- Any gaps flagged

Then immediately dispatch next-action and state what to work on next.
