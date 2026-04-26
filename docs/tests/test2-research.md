# Test 2 Research: A2A Phase Design And Execution Strategy

## Goal
Define a practical, low-risk Phase 2 implementation strategy for Python agent-to-agent collaboration, reusing Test 1 MCP foundations.

## Context Carried From Test 1
- MCP server/client fundamentals are implemented and validated in `/workspaces/agent-python-test-1-mcp`.
- Baseline quality gates exist (ruff + pytest + coverage >= 90%).
- Release tags exist (`v0.1.0`, `v0.1.1`) and `.agent-state` tracking is in place.

## Core Design Decision
Adopt a two-agent local topology first:
1. Orchestrator agent:
   - accepts top-level requests
   - plans and delegates
   - aggregates/normalizes responses
2. Worker agent:
   - executes bounded task types
   - invokes MCP capabilities where needed
   - returns typed results

Rationale:
- Keeps boundaries explicit and testable.
- Avoids introducing framework complexity too early.
- Builds directly on Test 1 MCP implementation knowledge.

## Protocol/Contract Strategy
Use strict typed contracts for all A2A messages:
- DelegationRequest
- DelegationResult
- ErrorEnvelope
- Correlation metadata (request_id, parent_request_id, timestamps)

Rationale:
- Enforces deterministic behavior and easier debugging.
- Prevents hidden schema drift between agents.

## Transport Strategy
Start with in-process or local process transport abstraction with pluggable interface:
- `TransportAdapter` interface
- local adapter for immediate execution
- future adapter for HTTP/message bus without core orchestration rewrite

Rationale:
- Enables fast implementation now and cloud readiness later.

## Error Model Strategy
Define controlled failure classes:
- validation_error
- unsupported_task
- execution_error
- timeout_error

Every failure returns a normalized envelope with:
- machine-readable code
- human-readable summary
- correlation ID

## Test Strategy
Mandatory categories:
1. Unit
- model validation
- planner/routing decisions
- normalization logic

2. Regression
- guards for previously fixed bugs (schema mismatch, routing fallback)

3. Integration
- orchestrator -> worker request/response lifecycle
- worker -> MCP call handoff where applicable

4. Smoke
- startup + one full delegation call

5. Load
- lightweight concurrent delegation baseline

## CI Strategy
Minimum gates for Phase 2:
- `ruff check .`
- `pytest` with coverage report and fail-under 90

## Documentation Strategy
README must include:
1. End-to-end A2A ASCII architecture.
2. Repository tree with key modules.
3. Runbook commands for local setup, run, and validation.

`.agent-state` must be maintained each run:
- progress YAML
- evidence markdown
- append-only execution log JSONL
- metrics summary JSON

## Risks And Mitigations
1. Risk: over-coupling orchestrator and worker internals
- Mitigation: enforce strict message contracts and adapter boundaries.

2. Risk: flaky load thresholds in shared dev/CI environments
- Mitigation: conservative baseline thresholds and environment-aware tuning.

3. Risk: premature framework lock-in
- Mitigation: keep phase framework-neutral; add LangChain next phase.

4. Risk: observability gaps in multi-step delegation
- Mitigation: correlation IDs and structured logs at each hop.

## Recommended Build Order
1. Bootstrap new repo and baseline tooling.
2. Implement contracts and transport abstraction.
3. Implement worker agent behavior.
4. Implement orchestrator routing/delegation.
5. Add tests by category.
6. Add docs + CI hardening + `.agent-state` evidence.

## Go/No-Go For Test 2 Completion
Go:
1. End-to-end delegation path passes.
2. All test categories pass.
3. Coverage gate >= 90%.
4. README and `.agent-state` are complete.

No-Go:
1. Any boundary contract is untyped or unvalidated.
2. Delegation flow cannot be reproduced deterministically.
3. Required test categories are missing.
