# AGENTS.md

---
version: "2.0"
description: "Root agent policy. Keep this file language-neutral; place runtime-specific rules under config/<language>/."
---

# Agent Operating Guide

## Scope

- This file defines repository-wide agent behavior.
- Keep this file language-neutral.
- Put language or framework rules under `config/<language>/instructions/` and `config/<language>/prompts/`.
- When a task is language-specific, load the matching guidance before implementation.

## Core Principles

- Prefer established templates, libraries, and reference architectures over bespoke boilerplate.
- Do not re-invent the wheel.
- Keep changes differential and concise.
- Favor deterministic, reproducible outputs.
- Always know exactly where you are in terms of codebase, repo, and directory location.
- Ask before proceeding when requirements, target directory, branch, or version are unclear.
- Protect privacy. Never expose secrets or log PII; mask sensitive values in logs and error messages.
- Any assumptions made must be clearly defined and validated each time it's considered.
- Do not delete files unless you have a backup or have a way to restore them. If needed, create a temp backup folder to save files before permanently deleting files. Give user an option to delete backup files later.

## Documentation Standards

- Add docstrings on public functions and classes when intent is not obvious.
- Prefer comments that explain why a decision exists, not what the code mechanically does.
- Keep README setup and architecture guidance current when scaffold or runtime expectations change.
- Documentation requirements must be machine-enforced, not only instruction-based guidance.
  For new Python repositories, require docstring coverage checks in CI (for example,
  `interrogate` with a fail threshold) so undocumented public code fails the build.
- For non-trivial modules, require module-level docstrings that explain purpose, critical constraints, and design tradeoffs.
- For non-trivial functions and methods, require docstrings with purpose, args, return value, and raised errors when relevant.
- Tests should document pass criteria in docstrings so failures are diagnosable without reverse-engineering assertion details.
- Every new repository README must include:
  - An ASCII architecture diagram showing components, data flow direction, transport, and protocol.
  - A repository structure tree showing all source directories and key files with inline annotations.

## Standard Workflow

0. When your are given a task, always follow this order:
    a. Do not make assumptions and if needed, ask for more info from users. 
    b. Research thoroughly not only for happy scenarios but also for negative scenarios
    c. Plan based on your research that are supported by citable sources
    d. Execute the plan
    e. Validate your Execution to make sure it's inline with the research and plan 
1. Identify the applicable repository guidance and language/runtime guidance.
2. Verify target versions from repository evidence before implementation.
3. State the chosen template, library, or architecture path when it materially affects the solution.
4. Make the smallest complete change that satisfies the request.
5. Validate with real tests or checks. Do not simulate validation.

## Version And Documentation Fidelity

### Canonical Source

- This file is the root policy for repository-wide behavior.

### Required Verification

- Identify target versions from repository evidence in this order:
  - lockfiles: `uv.lock`, `poetry.lock`, `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `Cargo.lock`
  - manifests: `pyproject.toml`, `requirements.txt`, `package.json`, `pom.xml`, `build.gradle`, `go.mod`
  - internal specs: `openapi/`, versioned documentation in the repository
- If version evidence is missing or conflicting, stop and ask for confirmation.
- In final delivery, include a brief version-check note stating which file established the version.

### Policy

- Match implementation to the documented version used by the target project.
- Do not mix examples or APIs from incompatible versions.
- Apply best practices appropriate to the verified version, not whatever is newest.

## Quality Expectations

- Production quality is the default expectation, not a follow-up pass.
- Do not re-implement standard library or framework capabilities unnecessarily.
- Keep code modular, testable, and readable.
- Prefer shorter guidance and clearer code when behavior is preserved.
- If a language-specific quality checklist exists, treat it as mandatory for that language.

## Interaction Rules

- No filler.
- Focus on architecture and decision quality rather than basic syntax explanations unless asked.
- Restate understanding before multi-step work when the task has meaningful ambiguity or scope.
- Do not assume unstated requirements.

## Git Workflow Policy

The main branch is `main`.

### Branching Rules

- Never commit major changes directly to `main`.
- Use feature branches for major changes:
  - `feat/<milestone>-<short-description>`
  - `fix/<milestone>-<short-description>`
  - `chore/<milestone>-<short-description>`

### Major Change Definition

A change is major if any of the following is true:

- public behavior, schema, interface, or compatibility changes
- security or compliance changes
- architecture or dependency changes
- build, deploy, release, or configuration model changes
- more than 5 files changed, or any single file change exceeds 200 lines

### Minor Change Definition

Minor changes may stay on `main` only when all are true:

- no public behavior or compatibility change
- no security or compliance impact
- no build or deploy impact
- 5 or fewer low-risk files

### Merge And Push Rules

- Merge major changes through pull requests.
- Keep PR descriptions clear about scope, risk, and rollback.
- Ask before pushing to origin unless explicitly instructed to push.

### Release Traceability

Every major change should map to:

- branch name
- PR or merge commit
- semantic version tag
- milestone identifier

### Minimum Execution Sequence

1. `git checkout main && git pull --ff-only`
2. `git checkout -b <feature-branch>`
3. Implement and commit changes on the feature branch.
4. Merge through PR intent or approval.
5. `git tag -a vX.Y.Z -m "Milestone: <name>; Summary: <text>; Date: <UTC>"`
6. `git push origin main --tags`
7. Record the major-change rationale in PR or commit notes.

## Repository Layout Guidance

- Root `AGENTS.md` should stay short and policy-oriented.
- Put detailed language rules in `config/<language>/instructions/`.
- Put compatibility or discovery prompts in `config/<language>/prompts/`.
- Avoid duplicating the same rule across root policy, prompts, and instructions unless one file is explicitly a compatibility mirror.