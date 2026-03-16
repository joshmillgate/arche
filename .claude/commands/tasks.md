---
description: View and manage the project task list. Run with no arguments to see all active tasks. Usage: /project:tasks [add / done / block / next]
argument-hint: [add "task description" for:feature-name | done T5 | block T3 "reason" | next]
allowed-tools: Read, Write, Edit, Glob
disable-model-invocation: true
---

Task list operation requested: $ARGUMENTS

Read context/project/TASK-LIST.md first.

---

## If $ARGUMENTS is empty — show full task list

Print the task list in a clean readable format:

**Active Sprint**
[T-number] [status] [description] → [feature name if linked]

**Blocked**
[T-number] [description] — waiting on: [reason]

**Backlog** (top 10)
[T-number] [description] → [feature name if linked]

**Done this week** (last 5 completed)
[T-number] [description]

Then ask: "Want to add a task, mark one done, or see anything else?"

---

## If $ARGUMENTS starts with "add"

Parse the task description from the argument.
Find the highest existing T-number and assign the next one.

Ask the user:
1. Which feature does this belong to? (show list of feature files to choose from)
2. Should this go in Active Sprint or Backlog?
3. Any notes or dependencies?

Then:
- Add the task row to the correct section of TASK-LIST.md
- If a feature was specified, add the task row to that feature file's Tasks table too
- Confirm: "Added T[N]: [description]"

---

## If $ARGUMENTS starts with "done"

Parse the T-number(s) from the argument (e.g. "done T5" or "done T5 T6 T7").

For each T-number:
- Find the task row in TASK-LIST.md
- Change status to `[x]`
- Move the row to the Completed section with today's date
- Find the matching row in the feature file if one is linked, update it there too

Confirm: "Marked complete: T[N] — [description]"

---

## If $ARGUMENTS starts with "block"

Parse the T-number and reason (e.g. "block T3 waiting for API keys").

- Move the task to the Blocked section in TASK-LIST.md
- Add the blocking reason
- Update the feature file if linked

Confirm: "T[N] marked as blocked: [reason]"

---

## If $ARGUMENTS is "next"

Read the Active Sprint. Find the highest priority incomplete `[ ]` task.
If Active Sprint is empty, look at the top of Backlog.

Say:
"Your next task is:
  [T-number] [description]
  Feature: [feature name and link if applicable]
  [any notes or dependencies]

Want me to start working on it?"

If the user says yes, proceed to build that specific task following the same
flow as /project:build but scoped to this single task.
