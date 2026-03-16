---
description: Build a feature end-to-end — scope check, spec, build, review, tests, context and task list update. Usage: /project:build [feature name or description]
argument-hint: [feature name or description]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
disable-model-invocation: true
---

## Core Rule for This Command

Never tell the user to run a command. Run it yourself and report the outcome in plain English.
If something fails, diagnose and fix it — don't paste error output at the user.

The user wants to build: $ARGUMENTS

Run the full feature pipeline in order.

## Pre-flight Check
Before anything else, check node_modules exists. If not, run npm install silently
and tell the user "Installing dependencies..." — do not ask them to do it.
If the install fails, diagnose it and fix it before continuing.

## Step 1 — Scope Check
Dispatch scope-checker to verify this is within the agreed project scope.
If out of scope or unlisted, stop and discuss before continuing.

## Step 2 — Feature Spec and Task List
Check context/features/ for an existing spec.
- If a complete spec with Tasks section exists: read it, confirm with user, proceed to Step 3
- If no spec exists: dispatch feature-planner to create one including the Tasks table and TASK-LIST.md entries

Read context/project/TASK-LIST.md — identify which T-numbers belong to this feature.
Mark the relevant tasks as `[~]` in progress in both TASK-LIST.md and the feature file.

## Step 3 — Build
Work through the feature's task list in order.
After completing each individual task:
- Mark it `[x]` in the feature file Tasks table
- Mark it `[x]` in context/project/TASK-LIST.md and move it to Completed
- Tell the user which task just finished and what's next

This way the user can see real-time progress through the task list, not just a final result.

## Step 4 — Review
Dispatch code-reviewer.
Present findings to the user.
Fix any Must Fix items before continuing.

## Step 5 — Tests
Dispatch test-writer to write test coverage.
Run the tests yourself. Report the outcome as:
  "All tests passing" or "2 tests failed — fixing now"
Never tell the user to run the tests themselves.

## Step 6 — UAT (User Acceptance Testing)

This is the human-in-the-loop step. The user validates the feature in their real browser.

First, make sure the dev server is running. If it isn't, start it now.
Then dispatch uat-guide to generate the browser test checklist for this feature.

Present the checklist to the user and say:
  "The code is built and tests are passing. Before I move on, I'd like you to
   try it out in your browser — [URL]. Work through the steps above and let me
   know what you see."

Then WAIT. Do not proceed to Step 7 until the user responds.

### If the user says everything looks good:
Proceed to Step 7.

### If the user reports a problem:
- Ask them to describe exactly what they saw (or paste any error text)
- Diagnose and fix the issue in the main session
- Re-run the automated tests to confirm the fix
- Ask the user to re-test the specific step that failed
- Only proceed when they confirm it's working

### If the user reports a partial pass:
- Fix the failing steps, leave passing steps alone
- Ask the user to re-test only the steps that failed
- Do not ask them to re-test everything from scratch

---

## Step 7 — Context and Task Update
Dispatch context-updater to:
- Mark all feature tasks as complete
- Update the feature status to `complete`
- Update the UAT status in the feature file to `passed`
- Sync any other context files that changed

## Done
Tell the user briefly:
- What was built
- That UAT passed
- Which tasks were completed (T-numbers)

Then immediately dispatch next-action and state the next task.
Do not ask "what would you like to do next?" — the task list answers this.
