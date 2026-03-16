---
description: Review code before committing — runs the code-reviewer agent and presents findings. Usage: /project:review [file, folder, or feature name — optional]
argument-hint: [file path or feature name — leave blank to review recent changes]
allowed-tools: Read, Bash(git diff:*), Bash(git status:*), Glob, Grep
disable-model-invocation: true
---

The user wants a code review. Scope: $ARGUMENTS

## Determine What to Review
- If $ARGUMENTS specifies a file or folder: review that
- If $ARGUMENTS specifies a feature name: find the relevant files in context/features/ then review the implementation
- If $ARGUMENTS is blank: run !`git diff HEAD` and !`git status` to find recent changes, review those

## Run the Review
Dispatch the code-reviewer agent with the files to review.

## Present Results
Show the full review report to the user.

## Next Steps
Based on the review findings, suggest:
- If Must Fix items exist: offer to fix them now with /project:fix
- If tests are missing: offer to add them with the test-writer agent
- If context needs updating: offer to run context-updater
