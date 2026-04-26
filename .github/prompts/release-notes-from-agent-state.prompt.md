---
description: "Generate release notes from .agent-state evidence and git tags for phased project delivery. Keywords: release notes, changelog, evidence, tags, phase summary."
name: "Release Notes From Agent State"
argument-hint: "Provide target repo path and optional tag range (for example: v0.1.0..v0.1.1)."
agent: "Plan Phase Executor"
tools: [read, search, execute]
---
Generate production-ready release notes for the target repository using persistent agent artifacts and git history.

## Inputs
- Target repository path
- Optional tag range

## Required Data Sources (in order)
1. .agent-state/evidence/*.md (most recent first)
2. .agent-state/progress/*.yaml
3. .agent-state/metrics/summary.json
4. git tags and commits

## Method
1. Identify current release tag and previous tag.
2. Build a change set from git log between tags.
3. Correlate each change with evidence artifacts.
4. Include validated test/CI outcomes from evidence and metrics.
5. Call out blocked/deferred items explicitly.

## Output Format
1. Release
- Version
- Date (UTC)
- Tag range

2. Highlights
- 3 to 7 concise bullets

3. Changes By Area
- CI and quality gates
- Runtime or architecture
- Tests and reliability
- Documentation and operations

4. Validation Summary
- Tests passed/failed
- Coverage and thresholds
- Lint status

5. Deferred Or Known Gaps
- Explicit list with risk level

6. Evidence Index
- File references to .agent-state artifacts
- Commit and tag references

Do not invent data. If a field is missing, mark it as "Not available".
