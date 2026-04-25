# Test 2 Plan: Phase 2 A2A Repository Execution Plan

## Objective
Create a Phase 2 repository for agent-to-agent delegation in Python, using strict contracts, deterministic validation, and enterprise quality gates.

## Target Repository
- `/workspaces/agent-python-test-2-a2a`

## Inputs
Derived from:
- `/workspaces/agents/tests/test2-learning.md`
- `/workspaces/agents/tests/test2-research.md`

Dependency reference:
- `/workspaces/agent-python-test-1-mcp` (MCP baseline reused by worker agent)

## Scope
In scope:
1. Two-agent architecture (orchestrator + worker).
2. Typed A2A message contracts.
3. Local-first transport adapter.
4. Full test categories: unit, regression, integration, smoke, load.
5. CI gates: lint + coverage-aware tests.
6. Persistent `.agent-state` artifacts.

Out of scope:
1. LangChain integration.
2. Production cloud deployment execution.

## Deliverables
1. New repository scaffold at `/workspaces/agent-python-test-2-a2a`.
2. `src` modules for:
- contracts/schemas
- orchestrator agent
- worker agent
- transport adapter
- logging utilities
3. Tests under required categories.
4. README with ASCII architecture and repo tree.
5. CI workflow with lint and test coverage gating.
6. `.agent-state` artifacts maintained per run.

## Technical Plan

### Step 1: Bootstrap Repository
Actions:
1. Initialize Python repo with `uv` and baseline structure.
2. Configure lint, pytest, and coverage gate >= 90.
3. Add `.github/workflows/ci.yml` baseline.

Exit criteria:
- Repo setup commands succeed and CI config is valid.

### Step 2: Define A2A Contracts
Actions:
1. Implement Pydantic models for request, response, and error envelope.
2. Add correlation metadata fields.
3. Add validation tests for edge cases.

Exit criteria:
- Contracts are strict and unit-tested.

### Step 3: Implement Worker Agent
Actions:
1. Build worker task execution interface.
2. Integrate worker-side call path to MCP capability where needed.
3. Normalize success and error outputs.

Exit criteria:
- Worker handles valid and invalid tasks deterministically.

### Step 4: Implement Orchestrator Agent
Actions:
1. Implement routing/planning logic.
2. Delegate to worker using transport adapter.
3. Aggregate and normalize final response.

Exit criteria:
- One end-to-end delegation flow works locally.

### Step 5: Add Test Categories
Actions:
1. Unit tests for models and orchestration logic.
2. Regression tests for known failure patterns.
3. Integration tests for orchestrator <-> worker flow.
4. Smoke test for one complete request lifecycle.
5. Load baseline test for concurrent delegation.

Exit criteria:
- All categories exist and pass with reproducible commands.

### Step 6: Final Validation And Release Readiness
Actions:
1. Run lint and full test suite with coverage gate.
2. Verify README completeness and reproducibility.
3. Verify `.agent-state` artifacts updated for this run.
4. Verify commit/version/tag readiness.

Exit criteria:
- Phase 2 repo is review-ready and release-ready.

## Validation Matrix
1. Contract correctness
- Evidence: unit tests for schemas and error envelope.

2. Delegation correctness
- Evidence: integration tests demonstrating orchestrator -> worker round trip.

3. Reliability baseline
- Evidence: smoke and load test outcomes.

4. Test completeness
- Evidence: all five required categories present and passing.

5. Documentation quality
- Evidence: README architecture + runbook + repo tree.

## Risks And Mitigations
1. Risk: hidden coupling across agents
- Mitigation: strict contracts and adapter interfaces.

2. Risk: transport refactor churn later
- Mitigation: adapter abstraction from day 1.

3. Risk: unstable load timing
- Mitigation: realistic baseline threshold and tuning notes.

4. Risk: incomplete run traceability
- Mitigation: mandatory `.agent-state` updates each run.

## Go/No-Go Criteria
Go:
1. End-to-end A2A flow passes.
2. Lint/test/coverage gates pass.
3. `.agent-state` artifacts are current.
4. README and CI are complete.

No-Go:
1. Missing test category.
2. Unvalidated message boundary.
3. Non-reproducible validation process.

## Handoff Artifacts
1. Repository path and structure summary.
2. Category-by-category test summary.
3. Delegation flow evidence summary.
4. Known gaps and recommendation for Phase 3 planning.
