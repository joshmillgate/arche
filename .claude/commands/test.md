---
description: Generate a browser test guide for the user to follow. Use after any feature build, or any time you want to validate what's in the app. Usage: /project:test [feature name — leave blank to test the most recently built feature]
argument-hint: [feature name — optional]
allowed-tools: Read, Write, Bash, Glob
disable-model-invocation: true
---

The user wants to test: $ARGUMENTS

## Step 1 — Identify What to Test

If $ARGUMENTS is blank:
- Read context/project/TASK-LIST.md
- Find the most recently completed task (last entry in Completed section)
- Use that feature as the test target
- Tell the user: "Testing the most recently completed feature: [name]"

If $ARGUMENTS names a feature:
- Find the matching file in context/features/
- If not found, list available features and ask which one

## Step 2 — Check the Dev Server

Check if the dev server is running by scanning common ports.
If it's not running, start it now and wait for it to be ready.
Tell the user the URL once it's up.

## Step 3 — Generate the UAT Checklist

Dispatch uat-guide with the identified feature.

## Step 4 — Present and Wait

Show the checklist to the user.

Say:
  "Your app is ready at [URL]. Work through these steps and tell me what you see.
   If anything looks wrong at any step, just describe it or paste any error text —
   I'll fix it straight away."

Then WAIT for their response. Do not move on.

## Step 5 — Handle the Response

### "Everything looks good" / "All working" / "Passed"
Say: "Great — [feature] is confirmed working."
Update context/features/[feature-name].md:
- Set UAT Status to `passed`
- Set Last tested to today's date
- Set Outcome to "Passed — user confirmed all steps working"
Dispatch next-action.

### They describe a problem
- Diagnose it from their description
- Fix it in the main session (run the server, check logs, read the relevant code)
- Tell them what you found and what you fixed, in plain English
- Ask them to re-test just the step that failed
- Repeat until they confirm it's fixed

### They paste an error message or screenshot
- Read it carefully — translate the technical parts into plain English for them
  ("The app can't connect to the database" not "ECONNREFUSED 127.0.0.1:5432")
- Fix it without asking them to do anything technical
- Tell them what it was and how you fixed it
- Ask them to try again

### "I'm not sure what I'm looking at"
- They may be confused about what to expect
- Clarify the specific step they're on in simpler terms
- Give them a more explicit description of what they should see
