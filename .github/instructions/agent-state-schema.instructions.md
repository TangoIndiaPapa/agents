---
description: "Use when executing phased plans with persistent state, updating .agent-state artifacts, validating task progression, or reporting run evidence and metrics. Keywords: .agent-state, progress yaml, execution logs, metrics summary, evidence markdown."
name: "Agent State Artifact Schema"
applyTo: ".agent-state/**"
---
# Agent State Artifact Schema

Use this schema whenever an agent executes phased work and must preserve state across runs.

## Required Layout

Target repository must contain:
- .agent-state/README.md
- .agent-state/progress/
- .agent-state/evidence/
- .agent-state/logs/
- .agent-state/metrics/

## Required Files Per Run

1. Progress state
- Path: .agent-state/progress/<plan-slug>.yaml
- Must include:
  - plan_id
  - phase_id
  - task_id
  - status (not-started | in-progress | blocked | completed)
  - updated_at_utc
  - evidence (list of file paths, command summaries, commit refs, tag refs)
  - blockers (list)
  - resolutions (list)

2. Evidence summary
- Path: .agent-state/evidence/<timestamp>-<phase>.md
- Must include:
  - Objective
  - Completed actions
  - Validation commands and outcomes
  - Risks and deferred work

3. Execution log
- Path: .agent-state/logs/execution.jsonl
- Append-only, one JSON object per major action.
- Required keys per object:
  - timestamp
  - action
  - targets
  - command
  - exit_code
  - duration_ms
  - summary

4. Metrics summary
- Path: .agent-state/metrics/summary.json
- Recomputed each run with:
  - total_tasks
  - completed_tasks
  - blocked_tasks
  - failed_validations
  - pass_rate
  - last_run_utc

## Validation Rules

- Never delete prior execution log rows.
- Keep YAML and JSON syntactically valid.
- Evidence pointers in progress YAML must map to existing files/refs.
- If code or CI files changed during a run, at least one .agent-state artifact must also be updated.

## Reporting Rules

Final status reports should include:
- Which .agent-state artifacts were updated
- Validation results tied to evidence files
- Commit and tag references used as evidence anchors
