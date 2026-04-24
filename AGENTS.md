# AGENTS.md

## Git Workflow Policy

This repository uses a controlled change workflow to keep main clean and auditable.

### Branching Rules
- Never commit directly to main for major changes.
- For each major change, create a feature branch from main.
- Branch naming convention:
  - feat/<milestone>-<short-description>
  - fix/<milestone>-<short-description>
  - chore/<milestone>-<short-description>

### Merge Rules
- Merge feature branches through pull requests.
- Keep a clear PR title and description with scope, risk, and rollback notes.
- Do not bypass review for major changes.

### Tagging and Milestones
- After merge to main for a major change, create an annotated tag.
- Use semantic versioning tags: vMAJOR.MINOR.PATCH.
- Tag message must include:
  - milestone name
  - change summary
  - date (UTC)

### Release Traceability
- Every major change should map to:
  - branch name
  - PR/merge commit
  - semantic version tag
  - milestone identifier

### Default Agent Behavior
When a user asks for a major repo change, agents should:
1. Create/switch to a feature branch.
2. Implement and commit changes on that branch.
3. Merge to main only after review intent is confirmed.
4. Create and push an annotated version tag after merge.
