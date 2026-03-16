---
description: Invoke the Opus deep-solver for complex bugs or architecture decisions. Will warn about 3-5x token cost before proceeding. Usage: /project:deep [describe the problem]
argument-hint: [describe the complex bug or architecture question]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
disable-model-invocation: true
---

The user has explicitly requested deep analysis for: $ARGUMENTS

## Cost Warning
Before doing anything else, tell the user:

  "You've invoked /project:deep which uses the deep-solver agent running on Claude Opus.
   Opus costs 3-5x more tokens than Sonnet — on Pro this can use a significant portion
   of your 5-hour window for a single complex task.

   This is worth it for:
     - Multi-file bugs with unknown root cause
     - Foundational architecture decisions (auth, data model, billing, real-time)
     - Problems where Sonnet has already failed

   Type 'yes' to proceed with Opus, or 'no' to try Sonnet first."

Wait for explicit confirmation. Do not proceed until the user says yes.

## If confirmed — dispatch deep-solver
Pass the full problem description to deep-solver: $ARGUMENTS

Also pass any relevant context:
- Read context/technical/ARCHITECTURE.md
- Read context/technical/DATA_MODELS.md  
- Read the most relevant feature spec from context/features/

## After deep-solver completes
Present the full report to the user.
Ask if they want to:
- Implement the recommended fix now
- Update the context files with decisions made
- Run a review after implementing
