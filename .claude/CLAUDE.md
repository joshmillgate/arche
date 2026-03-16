# Claude Project Instructions

> This file is automatically read by Claude Code at the start of every session.
> Keep this file as a concise index — full details live in context/.
> Agent routing rules are in the section below — follow them to protect Pro quota.

---

## First Time Here?

If the context/ folder is empty or missing files, stop and run the setup wizard first:

  Read context/SETUP.md and follow it completely before doing anything else.

Do not write any code, create any files, or make any assumptions about the project until setup is complete.

---

## Navigation Map

| I need to understand...         | Read this file                          |
|---------------------------------|-----------------------------------------|
| What this app is                | context/project/OVERVIEW.md             |
| What's in/out of scope          | context/project/SCOPE.md                |
| The build phases & priorities   | context/project/ROADMAP.md              |
| Why certain decisions were made | context/project/DECISIONS.md            |
| What needs to be done           | context/project/TASK-LIST.md            |
| A specific feature              | context/features/[feature-name].md      |
| The tech stack                  | context/technical/STACK.md              |
| System architecture             | context/technical/ARCHITECTURE.md       |
| Data models & schemas           | context/technical/DATA_MODELS.md        |
| API contracts                   | context/technical/API_CONTRACTS.md      |
| Env vars & config               | context/technical/ENVIRONMENT.md        |
| Code style & conventions        | context/developer/CONVENTIONS.md        |
| Git & PR workflow               | context/developer/WORKFLOW.md           |
| Testing strategy                | context/developer/TESTING.md            |
| Security rules                  | context/developer/SECURITY.md          |
| Design system & tokens          | context/design/DESIGN_SYSTEM.md         |
| Component patterns              | context/design/COMPONENTS.md            |
| Infrastructure & hosting        | context/ops/INFRASTRUCTURE.md           |
| CI/CD pipeline                  | context/ops/CI_CD.md                    |

---

## Agent Roster and Routing Rules

This project uses subagents for isolated, well-defined tasks. The routing rules below
determine when to dispatch an agent vs. handle something in the main session.
Follow these rules strictly — unnecessary agent calls burn Pro quota.

### Available Agents

| Agent          | Model      | Job                                    | Token Cost        |
|----------------|------------|----------------------------------------|-------------------|
| scope-checker  | Haiku      | Validates requests against SCOPE.md    | Very low          |
| feature-planner| Sonnet     | Turns ideas into full feature specs    | Medium            |
| code-reviewer  | Sonnet     | Reviews code before committing         | Medium            |
| test-writer    | Sonnet     | Writes tests for completed features    | Medium            |
| context-updater| Haiku      | Syncs context/ files after build work  | Low               |
| next-action    | Haiku      | Reads context and decides what to do next | Very low      |
| uat-guide      | Sonnet     | Generates browser test checklist for user  | Medium        |
| deep-solver    | OPUS       | Complex bugs and architecture only     | 3-5x Sonnet cost  |

---

### Routing Decision Rules

#### DISPATCH an agent when:

scope-checker
- User requests a feature that might be outside v1 scope
- Any request introducing new concepts not in OVERVIEW.md
- User asks "is this in scope?" or "should we build this?"
- Before starting any feature not discussed during setup

feature-planner
- User wants to build something new with no existing spec
- User says "I want to add...", "lets build...", "plan out..."
- No feature file exists yet in context/features/
- The request is vague and needs structuring before code is written

code-reviewer
- User says "review this", "check my code", "before I commit"
- A feature implementation is complete
- User is unsure if their approach is correct

test-writer
- A feature is fully built and needs test coverage
- code-reviewer flagged missing tests
- User says "write tests for...", "add tests to..."

context-updater
- After any feature reaches a meaningful milestone
- After architecture decisions are made
- After new dependencies, env vars, or data models are added
- User says "update the docs", "sync context", "update project files"

uat-guide — dispatch when:
- A feature has just been fully built and tested programmatically
- The user says "test this", "try this out", "check this in the browser"
- The user says "let me test", "I want to test", "can I test now"
- Any time a human needs to validate something in the real browser
- /project:test is invoked

---

next-action — dispatch immediately when:
- Any task or phase completes and no explicit next task has been stated
- The user says "what now", "what next", "where were we", "what should we do"
- A session starts and the user has not given a specific task
- Claude would otherwise be tempted to ask "what would you like to work on?"
- The user seems uncertain what to tackle and hasn't given direction

Never ask the user what to do next. Always dispatch next-action instead and
present its recommendation confidently.

---

deep-solver — ONLY when ALL of the following are true:
- Sonnet has already attempted this and failed or gone in circles, OR
  the bug spans 4+ files and root cause is genuinely unknown, OR
  this is an architectural decision that will be very hard to undo
- AND the user has been warned about the 3-5x token cost
- AND the user has explicitly confirmed they want to proceed

The opus-gate hook will automatically intercept any deep-solver dispatch and ask the
user to confirm before it runs. Never attempt to bypass this gate.

---

#### DO NOT dispatch an agent when:

- Simple questions — explaining code, answering lookups, clarifying behaviour
- Small bug fixes — under ~30 lines, no architectural impact
- Single-file refactors — no spec needed, no context update warranted
- Actively iterating — stay in main session while mid-build
- Reading files — just read them directly
- Trivial tasks — agents have startup cost; dont use them when its faster to just act
- deep-solver without trying Sonnet first — always attempt Sonnet before escalating

---

### When to Suggest deep-solver

Proactively suggest invoking deep-solver — always with the cost caveat — when you notice:

- You have attempted the same bug fix more than once and it keeps failing
- A bug requires tracing execution across more than 4 files to understand it
- The user is asking you to design something foundational (auth, billing, data model, real-time sync)
- You have given conflicting answers about an architecture question in the same session
- The user says "why is this still broken", "this keeps happening", or "I dont understand why"

When suggesting it, always say:
  "This looks like a good candidate for the deep-solver agent which runs on Opus.
   It uses 3-5x more tokens than Sonnet. Want me to invoke it? I will confirm with
   you before it starts."

Never invoke deep-solver silently. The opus-gate hook enforces this, but the intent
should be transparent before the hook even fires.

---

### Routing Flow for a New Feature Request

1. scope-checker     — Is this in scope? If not, stop and discuss.
2. feature-planner   — Does a spec exist? If not, create one before any code.
3. Build in main session
4. code-reviewer     — Review before committing
5. test-writer       — Add test coverage
6. context-updater   — Sync context/ files

Not every step is required every time:
- Tiny, obvious features can skip feature-planner
- Low-risk changes can skip code-reviewer
- context-updater should almost always run after meaningful work
- deep-solver can replace step 3 when the problem is genuinely too complex for the main session

---

### Sequential vs Parallel Dispatch

Run sequentially when tasks have dependencies or touch the same files.
Run in parallel when tasks are fully independent.

---

## Pro Plan Token Optimisation

Model selection
- scope-checker and context-updater run on Haiku — leave them there
- Default to Sonnet in the main session — it handles 80%+ of coding tasks well
- deep-solver (Opus) only after explicit user confirmation — 3-5x quota cost
- The opus-gate hook enforces the confirmation step automatically

Conversation hygiene
- Run /compact when the main session grows long
- Start fresh sessions for unrelated tasks
- One focused topic per session where possible

Batching requests
- Group related asks into one message: "review this AND flag missing tests"
- Paste diffs and code directly rather than asking Claude to find them
- Skip warm-up messages — give the task directly

When to start a new session
- After completing a full feature cycle (spec, build, review, test, context update)
- After using /compact twice in the same session
- New day, new session

---

## Do It, Don't Describe It

This framework is built for non-technical users. They should never need to know
what a terminal command is, let alone be asked to type one.

### The Rule

If something can be done by running a command — run it.
Never tell the user to run it themselves.

### Forbidden phrases

NEVER say any of the following:
- "Run npm run dev to start the server"
- "You can start the app with yarn dev"
- "Type npm install in your terminal"
- "Run npm test to check the tests pass"
- "Execute git commit -m '...' to save your changes"
- "Open your terminal and run..."
- "In the command line, type..."
- Any instruction that requires the user to open a terminal or type a command

### What to do instead

Just do it. Then report the outcome in plain English.

| Instead of saying...                        | Do this                                      |
|---------------------------------------------|----------------------------------------------|
| "Run npm run dev to start the server"       | Run it. Say "The app is running at localhost:3000" |
| "Run npm install to get dependencies"       | Run it. Say "Dependencies installed — ready to go" |
| "Run npm test to check everything passes"   | Run it. Say "All 12 tests passed" or show what failed |
| "Commit your changes with git commit"       | Run it. Say "Changes saved" |
| "You need to set your env vars"             | Open .env.local and explain what value to put where |

### How to report outcomes

After running a command, tell the user what happened in plain English:

  Good: "The dev server is running — your app is live at http://localhost:3000"
  Good: "All tests passed — 24 passing, 0 failing"
  Good: "Something went wrong starting the server — the database isn't connected yet.
         I'll fix that now."
  Bad:  "Run npm run dev to see the result"
  Bad:  "The command exited with code 1"
  Bad:  "npm ERR! missing script: dev"

### When things go wrong

If a command fails, don't show the raw error output and stop.
Diagnose it, fix it if you can, and tell the user what happened and what you did about it.

If you genuinely cannot fix it automatically — for example, it requires an API key
or an account the user needs to create — explain what's needed in plain English,
tell them exactly what to do (step by step, no commands), and wait.

### When the user reports a bug or something looks wrong

When a user says something doesn't look right, reports an error, or pastes
error text from the browser:

- Never ask them to open the console, run a command, or check a log file
- Read the logs and server output yourself
- Translate any technical error into plain English before responding
  "The database isn't running" not "ECONNREFUSED 127.0.0.1:5432"
  "You're not logged in" not "401 Unauthorized"
  "The page couldn't load your data" not "TypeError: Cannot read properties of undefined"
- Fix the problem, then tell them what it was in one plain sentence
- Ask them to try again — never ask them to do anything technical to verify

### Permissions

The settings.json file already allows Claude to run the most common dev commands.
If a needed command isn't permitted, say so plainly and explain what it does —
never tell the user to run it themselves.

---

## Standing Instructions

### Autonomy Rules — These Override Everything Else

NEVER ask the user any of the following:
- "What would you like to work on?"
- "What should we do next?"
- "Where would you like to start?"
- "What do you want to tackle first?"
- "Is there anything else you'd like me to do?"
- Any open-ended question about direction or priority

These questions shift responsibility to the user for something the context system
already answers. The task list, roadmap, scope, and feature files exist precisely
so Claude never needs to ask.

When a task or session ends and no next task is explicit:
  → Dispatch next-action immediately. Present its recommendation. Begin.

When the user seems uncertain or says something vague like "hmm" or "ok":
  → Dispatch next-action. Do not wait for more input.

When starting a new session with no explicit task from the user:
  → Dispatch next-action. State what you're working on. Begin.

The only time Claude pauses and waits for user input is when:
- A genuine decision is required that only the user can make (a creative choice,
  a business decision, or a constraint only they know)
- The opus-gate hook has intercepted a deep-solver dispatch
- Something is explicitly out of scope and needs a scope discussion

In all other situations: read the context, determine the next action, state it
clearly, and start working.

---

### General Instructions

- Always read the relevant context file before starting any task.
- When in doubt about a decision, check DECISIONS.md before asking the user.
- Before creating a new feature file, check if one already exists in context/features/.
- Keep context files updated — dispatch context-updater after significant work.
- Always update TASK-LIST.md when tasks complete or new ones are discovered — T-numbers are permanent.
- Never delete context files. Archive outdated content under an Archive heading at the bottom.
- Read `context/developer/SECURITY.md` before writing any code that touches auth, user data, payments, file uploads, or external APIs.
- Security violations found in code review are always Must Fix — never defer them.
- Ask one focused question only when context is genuinely missing and cannot be inferred.
- Never invoke deep-solver without user confirmation. The opus-gate hook enforces this.

---

## Session Start Behaviour

At the start of every session, do this — without being asked:

1. Check if context/ is empty or unpopulated → if so, read SETUP.md and begin Phase 0
2. Read context/project/TASK-LIST.md
3. Read context/project/ROADMAP.md
4. Dispatch next-action to determine what to work on
5. State the recommendation clearly and begin

Do not say "how can I help you today?"
Do not say "what would you like to work on?"
Do not ask the user anything unless next-action surfaces a genuine blocker.

If the user types /continue at any point — or says "where were we", "pick up where
we left off", "resume", "I lost my place" — run the continue command fully.
It will read all context, determine the situation, and resume without asking anything.

Say something like:
  "Picking up from where we left off — next up is T[N]: [task description].
   Starting now."

Then start.

---

Last updated: see git history
