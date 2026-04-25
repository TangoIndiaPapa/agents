# Test 2 Learning Brief: Phase 2 A2A Repository

## Role
You are mentoring a junior Python engineer who completed Test 1 (MCP fundamentals).

## Objective
Build Phase 2: agent-to-agent (A2A) collaboration where an orchestrator agent delegates work to a worker agent, and the worker uses MCP-backed capabilities.

## Why This Phase Matters
- Test 1 proved direct client-to-server MCP usage.
- Test 2 introduces delegation, coordination, and agent boundaries.
- This is the bridge from protocol basics to multi-agent workflows.

## Inputs
- Test 1 artifacts:
  - `/workspaces/agents/tests/test1-learning.md`
  - `/workspaces/agents/tests/test1-research.md`
  - `/workspaces/agents/tests/test1-plan.md`
- Test 1 implementation repo:
  - `/workspaces/agent-python-test-1-mcp`

## Expected Repository
- `/workspaces/agent-python-test-2-a2a`

## Scope
In scope:
1. A local-first Python A2A repository with two agents:
   - coordinator/orchestrator agent
   - worker/tool-execution agent
2. Clear message contract between agents.
3. Delegation flow with deterministic responses.
4. Tests by category: unit, regression, integration, smoke, load.
5. Persistent run-state artifacts under `.agent-state`.

Out of scope:
1. LangChain integration (reserved for next phase).
2. Production cloud deployment implementation.

## Technical Expectations
1. Python 3.12+, `uv` workflow.
2. Strong Pydantic v2 request/response models.
3. Clear separation of concerns:
   - agent contracts
   - orchestration logic
   - transport adapter
   - validation and logging
4. Deterministic failure modes for invalid delegation requests.

## Quality And Security Expectations
1. No hardcoded secrets.
2. Structured logging with request correlation IDs.
3. Explicit schema validation at every agent boundary.
4. CI must run lint and tests with coverage gate.
5. Keep coverage target at or above 90%.

## Delivery Requirements
1. README with architecture ASCII diagram and repo tree.
2. End-to-end demo path:
   - orchestrator receives user task
   - delegates to worker
   - worker executes capability
   - orchestrator returns normalized result
3. Evidence and metrics persisted in `.agent-state` each run.

## Acceptance Criteria
1. Delegation flow works end-to-end locally.
2. All test categories exist and pass.
3. CI quality gates pass.
4. `.agent-state` contains progress, evidence, logs, and metrics.
5. Repo is commit/tag ready for Phase 2 baseline.
