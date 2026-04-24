# AGENTS.md

## 1. Version And Documentation Fidelity Policy

### Where This Must Live
- Canonical source of truth: this `AGENTS.md` file.

### Non-Negotiable Rule
- Any library, SDK, framework, API, or CLI usage must match the exact documented version used by the target project.
- Agents must not mix examples from one version with implementation for another version.

### Required Verification Before Implementation
- Identify the target version from repository evidence first, in priority order:
  - lockfiles (`uv.lock`, `poetry.lock`, `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `Cargo.lock`)
  - manifest files (`pyproject.toml`, `requirements.txt`, `package.json`, `pom.xml`, `build.gradle`, `go.mod`)
  - internal API specs (`openapi/`, versioned docs in repository)
- If version evidence is missing or conflicting, stop and ask the user to confirm the exact version before proceeding.
- In the final response, include a short "version check" note stating what source established the version.

### Best Practices
- Ensure that best practices applied to the version in question which may not be the latest.

### PR And Commit Expectation
- For major changes involving dependencies or APIs, PR/commit notes should include:
  - selected library/API version
  - evidence source file
  - compatibility caveats or migration notes

## 2. Git Workflow Policy

Do not use master branch or any legacy terms. 
The main branch is 'main'.
This repository uses a controlled change workflow to keep main branch clean and auditable.

### Branching Rules
- Never commit directly to main for major changes.
- For each major change, create a feature branch from main.
- Branch naming convention:
  - feat/<milestone>-<short-description>
  - fix/<milestone>-<short-description>
  - chore/<milestone>-<short-description>

### Major Change Definition
A change is major if any one of the following is true:
- Behavior or contract changes:
  - Public API, schema, interface, or compatibility behavior changes.
- Security or compliance impact:
  - Authn/authz, secrets handling, policy files, audit/provenance, or access controls are changed.
- Architecture or dependency impact:
  - Core workflow refactor, framework/runtime migration, new critical dependency, or dependency major-version upgrade.
- Operational impact:
  - Build/deploy/release pipeline changes, environment/config model changes, or rollback complexity increases.
- Scope threshold:
  - More than 5 files changed, or any single file change exceeds 200 lines.

### Minor Change Definition
Minor changes can stay on main only when all are true:
- No public behavior or compatibility change.
- No security/compliance impact.
- No build/deploy pipeline impact.
- Small scope (5 or fewer files and low-risk edits such as docs, comments, typos, or non-functional formatting).

### Tie-Breaker Rule
If uncertain whether a change is major or minor, treat it as major and use a feature branch.

### Merge Rules
- Merge feature branches through pull requests.
- Keep a clear PR title and description with scope, risk, and rollback notes.
- Do not bypass review for major changes.
- Keep main stable and releasable.
- Do not perform direct major-change commits to main.

### Commit and Push Rules
- Unless explicitly told to commit and push to remote, ask for approval before you push to the origin.
- If explicitly asked to push to remote, then print the remote URL and execute the requested action.

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
5. Record why the change was classified as major in the PR/commit message.

### Minimum Execution Sequence
1. `git checkout main && git pull --ff-only`
2. `git checkout -b <feature-branch>`
3. Implement and commit changes on feature branch.
4. Merge to main through PR intent/approval.
5. `git tag -a vX.Y.Z -m "Milestone: <name>; Summary: <text>; Date: <UTC>"`
6. `git push origin main --tags`
7. Record major-change rationale in PR/commit notes.


