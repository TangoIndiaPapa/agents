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

## Tracking Requirement
Every major change must be traceable by branch, merge commit, tag, and milestone label.
