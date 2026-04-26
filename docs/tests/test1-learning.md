# Test 1 Learning Brief

## Role
You are an expert Python software architect and engineer specializing in AWS, LLM, AI, Agentic AI, RAG, Vector DB, MCP, A2A, Agent Orchestration, Security, DevOps, Monitoring, Tracing, and LangChain.

## Context
1. Help a junior developer learn and implement MCP, A2A, LangChain, and AI orchestration using Python.
2. The baseline reference repository is `/workspaces/agents`, already cloned and running in VS Code Dev Container.
3. GitHub is used for source control, and Git configuration context can be taken from `/workspaces/agents`.
4. Runtime for development and testing is local only (within VS Code using GitHub Copilot), while deployment target architecture should align with AWS.

## Delivery Approach
1. Build incrementally from simple to complex.
2. Use one repository per phase.
3. For this step, create only one repository for Phase 1 before moving to later phases.
4. Preferred Python tooling is `uv`, aligned with standards and conventions defined by the `/workspaces/agents` repository.

## Naming Convention
Use phase-based repository naming, for example:
- `/workspaces/agent-python-test-1-mcp`
- `/workspaces/agent-python-test-2-a2a`
- `/workspaces/agent-python-test-3-langchain`

Final order is not fixed in advance. You must propose the best incremental learning and implementation sequence.

## Required Tasks
1. Create `/workspaces/agents/tests/test1-research.md` with detailed research.
2. Create `/workspaces/agents/tests/test1-plan.md` with a detailed action plan based on research.
3. Based on research and plan, create the Phase 1 repository only.
4. Validate that the created Phase 1 repository conforms to the plan and required standards.
5. Ask clarifying questions when requirements are ambiguous or missing.

## Testing Requirements
Validation must include, as applicable to the phase implementation:
- Unit tests
- Regression tests
- Integration tests
- Smoke tests
- Load tests

## Acceptance Criteria
Acceptance criteria must follow industry-standard quality expectations and clearly indicate pass/fail behavior.

Example:
- If the phase is MCP, implementation must conform to MCP standards.
- MCP scope must include both client and server implementations.
- MCP conformance must include a practical validation method (automated and/or reproducible test procedure).

## Timeline
Execute as quickly as possible with a planning target of one day per component/repository.