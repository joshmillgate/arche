# Archē: The Vibecoding Framework

Archē is a vibecoding framework or "meta-context" that gives Claude everything it needs to build your app autonomously and efficiently. Designed for non-technical people who aspire to build and want Claude to work like a real collaborator.

<img width="1904" height="1000" alt="CleanShot 2026-03-16 at 20 42 43@2x" src="https://github.com/user-attachments/assets/99ac31b0-a5ea-49bb-ac29-93f3b607e4a0" />


---

## What This Is

This kit gives Claude everything it needs to understand your project deeply and work on it autonomously, from the first idea through to a live app. Instead of repeating yourself every session, Claude reads your project's context files and picks up exactly where it left off.

Built for non-technical people and technical people alike, this framework takes away the need to deeply understand technical concepts before you start building something.

---

## Getting Started

1. Open Claude Code in your project folder
2. Type `/start`
3. Answer Claude's questions, no technical knowledge needed
4. When setup is complete, type `/build [your first feature]` (This framework usually proceeds automatically)

---

## A Note on Command Names

Commands in this kit are typed directly in Claude Code. How they appear depends on your setup:

| In VS Code/IDE | In Claude Code CLI |
|---|---|
| `/start` | `/project:start` |
| `/build` | `/project:build` |
| `/continue` | `/project:continue` |
| `/fix` | `/project:fix` |
| and so on... | and so on... |

Both work identically, just use whichever form your environment shows. Type `/` to see all available commands listed in your setup.

---

## How a Project Works With This Kit

### 1. Setup — one conversation, done once

Planning and establishing context are simultaneously the most vital and tedious stages of building a successful vibecoded project. It is worth investing extra time to get this foundation right before you commence building. It can take a while to get this part complete, but perservere and the results will be worthwhile.

Run `/start`. Claude will have a friendly conversation with you and ask about:

- What you're building and who it's for
- The problem it solves
- The features you want
- The look and feel
- Your tech preferences — or Claude picks for you

By the end, Claude has generated a full `context/` folder — your project's brain. Every feature spec, every decision, every constraint lives there. Claude reads it automatically at the start of every session.

---

### 2. Building — the feature pipeline

Every feature is built through the same consistent pipeline. You say what you want to build, Claude handles the rest:

```
Scope check       Is this in the agreed plan?
      ↓
Feature spec      What exactly needs to be built?
      ↓
Build             Claude codes it, ticking off tasks as it goes
      ↓
Code review       Automatic quality check
      ↓
Automated tests   Claude runs the tests and fixes failures
      ↓
Browser testing   You try it in the app — Claude fixes anything wrong  ← the human step
      ↓
Context sync      All docs updated to reflect what was built
```

The key moment is **browser testing** — Claude gives you a plain-English checklist of things to try in your actual browser. You click around and report back. If anything looks wrong, just describe it and Claude fixes it. No technical knowledge required.

---

### 3. Ongoing — Claude always knows what's next

Claude never asks "what should we do next?" It reads the task list and roadmap and tells you. Every session starts with a clear statement of what's being worked on. When a task is done, the next one begins automatically.

If you close the chat and come back later, just type `/continue`, Claude will figure out exactly where things were and pick up from there without you having to explain anything.

---

## Commands

| Command | What it does |
|---|---|
| `/start` | **Start here.** Runs the setup wizard to understand your idea and generate all project context files. Run once on a new project. |
| `/continue` | Pick up where you left off. Claude reads the project state, figures out what was in progress, and resumes — no explanation needed. Use this any time you start a new session or feel lost. |
| `/build [feature]` | Build a feature end-to-end — spec, code, review, tests, browser testing, and docs. Example: `/build user login` |
| `/fix [bug]` | Fix a bug. Describe what's wrong in plain English and Claude investigates and fixes it. Example: `/fix the signup form isn't sending emails` |
| `/test [feature]` | Generate a browser test guide for any feature. Leave blank to test the most recently built feature. |
| `/review [file]` | Run a code quality review. Leave blank to review recent changes. |
| `/status` | See the current state of the project — active tasks, feature progress, recent work, and what's next. |
| `/tasks` | View and manage the task list. See active, blocked, and completed tasks. |
| `/tasks next` | Find out exactly what to work on next. |
| `/tasks add "description"` | Add a new task manually. |
| `/tasks done T5` | Mark a task as complete. |
| `/sync` | Sync all context files to reflect the current state of the codebase. Run if the docs feel out of date. |
| `/deep [problem]` | Invoke the Opus AI agent for complex bugs or architecture decisions. Claude will warn you about the higher cost before proceeding. |

---

## The Agents

Claude uses a set of specialist agents behind the scenes — each focused on a specific job. They're dispatched automatically; you never need to invoke them directly.

| Agent | What it does | Cost |
|---|---|---|
| `scope-checker` | Checks whether a request fits the agreed project plan before any work starts | Very low |
| `feature-planner` | Turns a feature idea into a detailed spec with user stories, edge cases, and a task breakdown | Low |
| `code-reviewer` | Reviews code for quality, security, and correctness before it's committed | Medium |
| `test-writer` | Writes automated tests for completed features | Medium |
| `uat-guide` | Generates the plain-English browser test checklist for you to follow | Medium |
| `context-updater` | Keeps all context files and the task list up to date after work completes | Very low |
| `next-action` | Reads the task list and roadmap to determine what to work on next | Very low |
| `deep-solver` | Deep investigation for complex bugs or architecture decisions. Uses the Opus model, requires your confirmation due to higher cost | High |

---

## The Build Pipeline in Detail

When you run `/build`, here's exactly what happens:

**Step 1 — Scope check**
Claude verifies the feature is within the agreed project plan before touching any code.

**Step 2 — Feature spec**
If no spec exists, Claude creates one. A breakdown of what the feature does, who uses it, the happy path, edge cases, and a task list. You review it before anything is built.

**Step 3 — Build**
Claude works through the task list one task at a time, marking each one complete as it goes. You see real progress, not just a finished result at the end.

**Step 4 — Code review**
An automatic review checks for quality issues, security problems, and anything that doesn't match your project's conventions.

**Step 5 — Automated tests**
Claude writes and runs tests. If any fail, it fixes them before continuing.

**Step 6 — Browser testing** ← the human step
Claude generates a friendly checklist of things to try in your actual browser. You follow the steps and report back. If anything looks wrong, describe it and Claude fixes it. This is the only step that requires you to do anything.

**Step 7 — Context sync**
All documentation is updated: task list, feature status, architecture notes, any decisions made during the build.

---

## The Context Folder

Everything Claude knows about your project lives in `context/`. Generated during setup and kept up to date automatically.

| Folder | What's inside |
|---|---|
| `context/project/` | The big picture — what you're building, scope, roadmap, decisions log, task list |
| `context/features/` | One file per feature — spec, tasks, and browser test results |
| `context/technical/` | Tech stack, architecture, data models, API contracts, environment variables |
| `context/developer/` | Code conventions, git workflow, testing strategy |
| `context/design/` | Design system, colour palette, typography, component patterns |
| `context/ops/` | Infrastructure, deployment pipeline, monitoring |

Claude reads from these files at the start of every session. You never need to re-explain your project.

---

## Key Principles

**Claude does the technical work, you make the decisions.**
You never need to open a terminal, run a command, or understand an error message. Claude runs everything and reports outcomes in plain English.

**The context folder is the project's memory.**
Everything gets written down — decisions, features, tasks, test results. Nothing lives only in a conversation.

**The task list drives everything.**
Every piece of work has a T-number and a status. Claude always knows what's next. You never need to manage a backlog manually.

**Human validation is built in.**
Every feature goes through browser testing before it's marked complete. You confirm it works in the real app, not just in tests.

**You can always pick up where you left off.**
Type `/continue` at the start of any session. Claude reads the project state and resumes — no re-explaining needed.

**Opus is available but gated.**
For genuinely complex problems, Claude can escalate to the more powerful Opus model. It always warns you about the higher cost and asks for your confirmation first.
