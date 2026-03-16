---
description: Fix a bug — investigates, traces root cause, fixes, and tests. Escalates to Opus deep-solver if genuinely complex. Usage: /project:fix [description of the bug]
argument-hint: [describe the bug or paste the error]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
disable-model-invocation: true
---

## Core Rule
Never show terminal commands to the user. Run everything yourself and report outcomes in plain English.
If an error message appears, translate it — never paste raw errors at the user.

The user has reported a bug: $ARGUMENTS

Work through this methodically. Do not guess.

## Step 1 — Understand the Bug
Before touching any code:
- What is the expected behaviour?
- What is the actual behaviour?
- When does it happen? (always / sometimes / specific conditions)
- Are there any error messages or stack traces?

If the user hasn't provided enough detail, ask one focused question to clarify.

## Step 2 — Locate the Problem
Read the relevant files. Trace the code path from trigger to symptom.
Use Grep to find all references to relevant functions, variables, or components.

## Step 3 — Assess Complexity
Before attempting a fix, honestly assess:
- Is the root cause clear from reading the code? → Fix it now (Step 4)
- Does this touch 4+ files with unclear cause? → Suggest deep-solver (Step 3a)
- Have you already attempted this fix once and failed? → Suggest deep-solver (Step 3a)

**Step 3a — deep-solver suggestion (only if needed):**
Say to the user:
  "This bug looks complex — it spans multiple files and the root cause isn't immediately clear.
   The deep-solver agent (Opus) is designed for exactly this. It will do a thorough investigation
   but uses 3-5x more tokens than Sonnet. Want me to invoke it, or should I attempt a fix first?"

Wait for the user's answer. If they say yes, dispatch deep-solver.
If they say no or want to try Sonnet first, proceed to Step 4.

## Step 4 — Fix
Make the minimal change needed to fix the root cause.
Do not refactor unrelated code. Do not "improve" things while you're in there.
Fix the bug. Nothing else.

## Step 5 — Verify
Run the tests yourself. Do not tell the user to run them.
Report: "All tests passing" or "1 test still failing — investigating"
If no tests cover this area, run the dev server and describe what the user
should see in the browser to confirm the fix worked.

## Step 6 — Update Context
If the bug revealed a gap in the specs or an undocumented edge case,
dispatch context-updater to log it.

## Done
Tell the user briefly:
- What the root cause was
- What was changed and why
- How to verify it's fixed

Then immediately dispatch next-action and state what to tackle next.
Do not ask what the user wants to do — the task list knows.
