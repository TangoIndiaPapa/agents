---
applyTo: "**"
description: "Use for all repository updates that require branch discipline, milestone tracking, merges, and release tags."
---

# Release Workflow Instruction

## Mandatory Git Controls
- For major changes, do not work on main.
- Create a feature branch first using:
  - feat/<milestone>-<short-description>
  - fix/<milestone>-<short-description>
  - chore/<milestone>-<short-description>

## Major Change Criteria
Treat the change as major if any one condition is met:
- Public behavior, API contract, schema, or compatibility changes.
- Security/compliance changes (authn/authz, secrets, policy, audit/provenance, access controls).
- Architecture or dependency changes (core refactor, runtime/framework change, major dependency upgrade).
- Build/deploy/release process changes or environment/config model changes.
- Scope threshold exceeded: more than 5 files changed or any file has a large edit (over 200 lines).

## Minor Change Criteria
Only treat as minor when all are true:
- No public behavior change.
- No security/compliance impact.
- No build/deploy/release impact.
- Small scope and low-risk edits (docs, comments, typo fixes, non-functional formatting).

## Tie-Breaker
If classification is unclear, classify as major.

## Main Branch Hygiene
- Keep main stable and releasable.
- Merge via PR workflow.
- Do not perform direct major-change commits to main.

## Tagging Rules
- After merge to main for a major change, create an annotated tag.
- Tag format: vMAJOR.MINOR.PATCH.
- Annotated message must include milestone and summary.

## Minimum Execution Sequence
1. `git checkout main && git pull --ff-only`
2. `git checkout -b <feature-branch>`
3. Implement and commit changes on feature branch
4. Merge to main through PR intent/approval
5. `git tag -a vX.Y.Z -m "Milestone: <name>; Summary: <text>; Date: <UTC>"`
6. `git push origin main --tags`
7. Record major-change rationale in PR/commit notes

## Tracking Requirement
Every major change must be traceable by branch, merge commit, tag, and milestone label.
