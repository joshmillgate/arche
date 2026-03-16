---
description: Pick up where you left off — reads the project state, figures out what was being worked on, and resumes without you needing to explain anything. Use this any time you start a new session or feel lost.
allowed-tools: Read, Write, Bash, Glob, Grep
disable-model-invocation: true
---

The user wants to resume work. Figure out exactly where things were and pick up from there.

Do not ask the user anything. Read the context and determine the state yourself.

---

## Step 1 — Check if setup has been run

Look for context/project/OVERVIEW.md and context/project/TASK-LIST.md.

If they don't exist or are empty placeholders:
  Say: "It looks like we haven't set up this project yet. Let me get that started."
  Then run the setup command — read context/SETUP.md and begin Phase 0.
  Do not continue past this point.

---

## Step 2 — Read project state

Read all of these:
- context/project/TASK-LIST.md — find the active sprint and any in-progress tasks
- context/project/ROADMAP.md — which phase, what's been completed
- context/features/ — scan all feature files for status and UAT status
- Run: !`git log --oneline -10`
- Run: !`git status`

---

## Step 3 — Determine what was happening

Work out which situation applies:

### A — There is a task marked [~] in progress
Something was actively being built when the session ended.
This is the most common case after closing a chat mid-build.

Identify:
- Which task (T-number and description)
- Which feature it belongs to
- What the git status shows (uncommitted work? partially written files?)
- How far along it looks based on existing code

### B — All active sprint tasks are [ ] todo, nothing in progress
The last session ended cleanly between tasks. Find the top task in the Active Sprint
and prepare to start it fresh.

### C — A feature was built but UAT is marked pending or in-progress
The code was finished but browser testing wasn't completed.
Resume at the UAT step — generate the test checklist and ask the user to test.

### D — Active sprint is empty
All planned tasks are done. Check the backlog for the next logical task.
If backlog is also empty, check ROADMAP.md for what phase comes next.

### E — Context files exist but git is clean with no recent commits
Setup ran but no code has been written yet.
Find the first feature in ROADMAP.md v1 Core and offer to start building it.

---

## Step 4 — Deliver a clear resumption summary

Present this to the user — keep it short and specific:

---
**Picking up from where we left off.**

**Project:** [one line from OVERVIEW.md]
**Current phase:** [from ROADMAP]

**What was happening:**
[Situation A: "We were mid-build on T[N]: [task description]. The code was partially written — [brief description of state based on git status]."]
[Situation B: "The last task completed cleanly. Next up is T[N]: [description]."]
[Situation C: "T[N] was built but not yet tested in the browser. Ready to pick that up."]
[Situation D/E: appropriate message]

**Starting now.**
---

Then immediately begin the work. Do not wait for the user to say "ok" or "yes".

- Situation A: resume building the in-progress task — read the relevant files, understand what's done, continue from where it left off
- Situation B: begin the next task — follow the same pipeline as /build for that specific task
- Situation C: dispatch uat-guide for the feature that needs browser testing, present the checklist
- Situation D: dispatch next-action to identify what comes next, then begin
- Situation E: begin building the first feature from ROADMAP

---

## If something looks broken or inconsistent

For example: git shows uncommitted changes to files that don't match the task list,
or a feature is marked complete but the code doesn't exist.

Say briefly what looks inconsistent, what you think happened, and what you're going to do about it.
Then fix it — don't ask the user to sort it out.
