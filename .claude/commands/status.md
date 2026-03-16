---
description: Show a quick project status overview — active tasks, feature progress, recent commits, and what's next.
allowed-tools: Read, Glob, Bash(git log:*), Bash(git status:*)
disable-model-invocation: true
---

Give a concise project status report. Keep it scannable — under 30 seconds to read.

Gather this information:

1. Read context/project/OVERVIEW.md — one line reminder of what this is
2. Read context/project/ROADMAP.md — which phase are we in
3. Read context/project/TASK-LIST.md — active sprint tasks and blocked tasks
4. Read context/features/ — scan each feature file for its status field
5. Run !`git log --oneline -8`
6. Run !`git status`

Then produce this report:

---
## Project Status

**What:** [one line from OVERVIEW]
**Phase:** [current phase from ROADMAP]

### Active Tasks
[List every task from the Active Sprint section with its T-number, status symbol, and description]
[If a task links to a feature file, show the feature name in brackets]

### Blocked
[List any blocked tasks and what they're waiting on — or "none" if clear]

### Feature Progress
[One line per feature: name — status — count of done/total tasks if available]

### Recent Commits
[Last 5 commits, one line each]

### Working Directory
[git status summary — clean / uncommitted changes / what files]

### Up Next
[The highest priority [ ] task from Active Sprint, or top item from Backlog if sprint is empty]
---

Be honest. If TASK-LIST.md looks stale or tasks haven't been updated to match recent commits, flag it.

After the report, dispatch next-action and append its recommendation at the bottom as:

**Recommended next action:** [next-action output]

Do not end the status report with a question.
