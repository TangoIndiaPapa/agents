# Comprehensive Plan: Agentic AI Ecosystem Implementation

**Date Created:** April 25, 2026  
**Plan Version:** 1.0  
**Status:** Ready for Execution  
**Target Completion:** Week 12 (end of Q2 2026)  
**Audience:** Agents (AI and human), Compliance & Regulatory Oversight Committee, DevOps, Architects

---

## Table of Contents

1. [Executive Overview](#executive-overview)
2. [Governance & Change Management](#governance--change-management)
3. [Prerequisites & Assumptions](#prerequisites--assumptions)
4. [Repository Structure](#repository-structure)
5. [Phase 0: Harness Kernel](#phase-0-harness-kernel)
6. [External Dependencies & Build vs. Reuse Strategy](#external-dependencies--build-vs-reuse-strategy)
7. [Phase 1: Protocol Adapters](#phase-1-protocol-adapters)
8. [Phase 2: Bootstrap Orchestrator](#phase-2-bootstrap-orchestrator)
9. [Phase 3: Specialized Agents](#phase-3-specialized-agents)
10. [Cross-Phase Integration Points](#cross-phase-integration-points)
11. [Recovery & Rollback Procedures](#recovery--rollback-procedures)
12. [Audit & Compliance Checklist](#audit--compliance-checklist)
13. [Success Criteria & Milestone Tracking](#success-criteria--milestone-tracking)

---

## Executive Overview

### Context Integrity & Memory Management (Mandatory)

To prevent memory rot, context dilution, hallucination, and lost goals in long-running agentic workflows, this plan enforces robust, auditable context and memory controls at every phase:

1. **Persistent Structured Memory**
  - All goals, decisions, and key facts are stored in structured memory files (`/memories/session/`, `/memories/repo/`).
  - Memory is updated after every major decision or context change.
  - Memory is regularly validated against current goals and plan.

2. **Context Window Management**
  - Old context is summarized and archived; only the most relevant, actionable data is kept in the active window.
  - Rolling summaries and “last known good” checkpoints are used to recover from context loss.

3. **Goal and Plan Traceability**
  - Every action, decision, and output is linked to a specific plan phase and goal.
  - Explicit goal restatement and plan alignment are required at each major step.

4. **Automated Consistency Checks**
  - Automated checks are run periodically to detect drift between plan, assessment, memory, and current state.
  - Execution is blocked if inconsistencies or lost goals are detected.

5. **Audit Logging and Recovery**
  - All major decisions and outputs are hash-chained for auditability.
  - Recovery and rollback protocols are provided at each phase.

6. **Human-in-the-Loop Verification**
  - Human review and sign-off are required at critical gates (e.g., before irreversible actions or phase transitions).

**Acceptance Criteria:**
- Context integrity controls are documented and enforced for every phase.
- Memory and context summaries are checkpointed and archived.
- Automated and human-in-the-loop checks for context drift, hallucination, and lost goals are in place.
- Recovery and rollback procedures for context/memory failures are documented.
This plan transforms `/workspaces/agents` (policy and scaffolding layer) into a production-ready agentic AI ecosystem with a functional harness kernel, protocol adapters, bootstrap orchestrator, and specialized agents.

### Key Principles

1. **Phase-Gated Delivery**: Each phase is independent and testable. No phase starts until the prior phase reaches "Complete" status.
2. **Checkpoint-Based Recovery**: Every deliverable includes a checkpoint tag (e.g., `CKPT-0.1-StateManager-Core`). Agents can resume from the most recent checkpoint.
3. **Audit-Trail Immutability**: Every step is logged in `/workspaces/agents/.agent-state/execution.jsonl` with hash chaining for tamper detection.
4. **State Persistence**: `.agent-state/` directory tracks all execution state, allowing agents to restart from any checkpoint without losing context.
5. **Compliance-First**: Design enforces enterprise security, rate limiting, authentication, authorization, structured logging, and 90% test coverage from inception.

### Timeline

| Phase | Duration | Start | End | Deliverable |
|-------|----------|-------|-----|------------|
| Phase 0: Harness Kernel | 3–4 weeks | Week 1 | Week 4 | `/workspaces/agents-harness/` package with 5 subsystems |
| Phase 1: Protocol Adapters | 1 week | Week 5 | Week 5 | External MCP integrations + custom wrappers for harness-specific services |
| Phase 2: Bootstrap Orchestrator | 2 weeks | Week 6 | Week 7 | MetaGPT-based orchestrator reading AGENTS.md |
| Phase 3: Specialized Agents | 2 weeks | Week 8 | Week 9 | First 3 specialized agents (Security, Test, Document) |
| Integration & Testing | 2–3 weeks | Week 10 | Week 12 | Full ecosystem validation; audit compliance |

---

## Governance & Change Management

### Branching Strategy

All work follows the Git workflow defined in `/workspaces/agents/AGENTS.md`:

```
main (protected)
  ├── feat/phase-0-harness-kernel
  ├── feat/phase-1-protocol-adapters
  ├── feat/phase-2-bootstrap-orchestrator
  ├── feat/phase-3-specialized-agents
  └── chore/integration-and-testing
```

**Branch Protection Rules**:
- PR required for all merges to `main`
- All tests must pass (pytest coverage ≥ 90%)
- All security checks must pass (bandit, safety)
- At least one approval from Architect or DevOps

### Assessment Template Gate (Mandatory Before Execution)

Before Phase 0 starts, complete the assessment template standard in `/workspaces/agents/tests/copilot-assessment-agentic-ai-eco-system.md` section `Assessment Template Standard (Build-vs-Reuse Mandatory)`.

Execution is blocked unless these artifacts exist:

1. **Build-vs-Reuse Inventory** covering major capabilities (Git, filesystem, process, web-fetch, validation, audit, orchestration, specialist agents)
2. **Decision Matrix** with explicit outcomes (`REUSE`, `REUSE+WRAP`, `BUILD`)
3. **Custom-Build Exception Register** for every `BUILD` decision
4. **Compliance Controls** for reused components (pinning, SBOM entry, security scan, fallback plan)
5. **Traceability Fields** mapped into checkpoint logs and audit entries

Required sign-off roles before proceeding:
- Architect
- DevOps
- Security

### Checkpoint Tagging

Every completed checkpoint is tagged in Git:

```bash
git tag -a vX.Y.Z-CKPT-<phase>.<subphase>-<name> \
  -m "Phase: <phase>; Checkpoint: <name>; Status: Complete; Date: <UTC>; Milestone: <description>"
```

Example:
```bash
git tag -a v0.1.0-CKPT-0.1-StateManager-Core \
  -m "Phase: 0; Checkpoint: StateManager (core); Status: Complete; Date: 2026-04-26T14:32:00Z; Milestone: State persistence and progressive disclosure"
```

### Resumption Protocol (Session/Machine Failure)

If execution is interrupted:

1. **Identify last completed checkpoint**: `git describe --tags --match "*-CKPT-*" --abbrev=0`
2. **Check state file**: `cat /workspaces/agents/.agent-state/current_checkpoint.txt`
3. **Load context**: `python -c "from agents_harness.state import StateManager; sm = StateManager(); print(sm.load_phase_state())"`
4. **Resume from next checkpoint**: See recovery procedures in [Recovery & Rollback Procedures](#recovery--rollback-procedures)

---

## Prerequisites & Assumptions

### Required Tools & Versions

| Tool | Version | Installation | Verification |
|------|---------|--------------|--------------|
| Python | ≥3.12 | `/usr/bin/python3` | `python3 --version` |
| uv | latest | `$HOME/.local/bin/uv` | `uv --version` |
| Git | ≥2.40 | System | `git --version` |
| ruff | ≥0.5.0 | `uv pip install ruff` | `ruff --version` |
| mypy | ≥1.11.0 | `uv pip install mypy` | `mypy --version` |
| pytest | ≥8.0.0 | `uv pip install pytest pytest-asyncio` | `pytest --version` |
| interrogate | ≥1.5.0 | `uv pip install interrogate` | `interrogate --version` |
| pydantic | ≥2.8.0 | `uv pip install pydantic` | `python -c "import pydantic; print(pydantic.__version__)"` |

### Environment Setup

Before beginning **any** phase:

```bash
# 1. Set PATH for uv
export PATH="$HOME/.local/bin:$PATH"

# 2. Verify working directory
cd /workspaces/agents
git status

# 3. Create virtual environment for harness development
uv venv /workspaces/agents-harness/.venv
source /workspaces/agents-harness/.venv/bin/activate

# 4. Initialize state directory
mkdir -p /workspaces/agents/.agent-state/{logs,evidence,metrics}

# 5. Verify Git is clean
git status | grep "nothing to commit" || { echo "ERROR: Uncommitted changes"; exit 1; }

# 6. Record environment state
python -c "
import json, sys, os, subprocess
state = {
    'timestamp': '$(date -u +%Y-%m-%dT%H:%M:%SZ)',
    'python_version': sys.version,
    'uv_version': subprocess.check_output(['uv', '--version']).decode().strip(),
    'git_branch': subprocess.check_output(['git', 'rev-parse', '--abbrev-ref', 'HEAD']).decode().strip(),
    'git_commit': subprocess.check_output(['git', 'rev-parse', 'HEAD']).decode().strip(),
    'working_directory': os.getcwd()
}
print(json.dumps(state, indent=2))
" > /workspaces/agents/.agent-state/environment-state.json
```

### Assumptions

1. **Source of Truth**: `/workspaces/agents/AGENTS.md` is the canonical policy document and will not be modified during Phase 0–3. Any policy changes are tagged as separate chores on the main branch.
2. **Dependency Isolation**: `/workspaces/agents-harness/` will be created as a new repository (sibling to `/workspaces/agents/`) and depends on `/workspaces/agents/` as a versioned input, not a live dependency.
3. **Python Version**: All code targets Python 3.12+. No compatibility with Python < 3.10.
4. **Async Runtime**: All async code uses `asyncio` with `pytest-asyncio` in mode `auto` (pinned ≥0.24,<1.0).
5. **No Breaking Changes to `/workspaces/agents`**: The policy repo remains read-only during harness development. The harness reads AGENTS.md as input, does not modify it.
6. **Enterprise Quality from Day 1**: Every service includes JWT/OAuth2 auth, RBAC, rate limiting, input validation (Pydantic strict mode), security headers, CORS, structured logging, and ≥90% test coverage. These are not optional.
7. **No Wheel Reinvention**: Use well-documented, production-grade external MCP servers and frameworks (Anthropic official, trusted communities) whenever they meet requirements. Build custom code only for harness-specific logic. Decision matrix in [External Dependencies & Build vs. Reuse Strategy](#external-dependencies--build-vs-reuse-strategy) governs all build vs. reuse decisions.

---

## Repository Structure

### Current State (`/workspaces/agents`)

```
/workspaces/agents
├── AGENTS.md                          # Root policy (read-only during harness dev)
├── RELEASE_NOTES.md
├── VERSION
├── CHANGELOG.md
├── LICENSE
├── config/
│   └── python/
│       ├── instructions/
│       │   ├── enterprise-python-checklist.md
│       │   └── python-code-generation-instructions.md
│       └── prompts/
├── skill/
│   ├── SKILL.md                       # Skill metadata & discovery
│   ├── write-unit-tests/SKILL.md
│   ├── security-audit/SKILL.md
│   ├── openapi-gen/SKILL.md
│   └── cloud-deploy/SKILL.md
├── tests/
│   ├── copilot-assessment-agentic-ai-eco-system.md
│   └── copilot-agentic-ai-eco-system-plan.md (THIS FILE)
├── .agent-state/
│   ├── agent-state-schema.instructions.md
│   ├── execution.jsonl               # Append-only audit log (created during plan exec)
│   ├── current_checkpoint.txt        # Last completed checkpoint (created during plan exec)
│   ├── logs/                         # Execution logs per phase
│   ├── evidence/                     # Artifacts & test results
│   └── metrics/                      # Performance & coverage metrics
├── scripts/
│   ├── create_python_repo.sh
│   └── create_python_fastapi_service.sh
└── .github/
    ├── instructions/
    │   ├── agent-state-schema.instructions.md
    │   └── enterprise-python-checklist.md
    └── AGENTS.md (symlink or copy)
```

### New Repository (`/workspaces/agents-harness`)

Will be created in Phase 0, following the scaffolding structure defined in `create_python_repo.sh`:

```
/workspaces/agents-harness
├── pyproject.toml                     # uv-managed dependencies
├── uv.lock                            # Locked versions (checked in)
├── README.md                          # Architecture & setup
├── VERSION                            # vX.Y.Z
├── CHANGELOG.md
├── LICENSE
├── src/
│   └── agents_harness/
│       ├── __init__.py
│       ├── state/                     # Phase 0.1: StateManager
│       │   ├── __init__.py
│       │   ├── manager.py
│       │   ├── models.py              # Pydantic schemas
│       │   └── tests/
│       ├── validation/                # Phase 0.2: ValidationMiddleware
│       │   ├── __init__.py
│       │   ├── middleware.py
│       │   ├── ruff_runner.py
│       │   ├── mypy_runner.py
│       │   ├── pytest_runner.py
│       │   ├── interrogate_runner.py
│       │   ├── boundary_checker.py    # AST-based layer enforcement
│       │   └── tests/
│       ├── worktree/                  # Phase 0.3: WorktreeManager
│       │   ├── __init__.py
│       │   ├── manager.py
│       │   ├── models.py
│       │   └── tests/
│       ├── audit/                     # Phase 0.4: AuditLogger
│       │   ├── __init__.py
│       │   ├── logger.py
│       │   ├── models.py
│       │   └── tests/
│       ├── gateway/                   # Phase 0.5: ToolGateway
│       │   ├── __init__.py
│       │   ├── gateway.py
│       │   ├── models.py
│       │   ├── loop_detector.py
│       │   └── tests/
│       ├── mcp/                       # Phase 1: MCP Servers (added later)
│       │   ├── git_server.py
│       │   ├── filesystem_server.py
│       │   ├── validation_server.py
│       │   └── audit_server.py
│       └── orchestrator/              # Phase 2: Orchestrator integration
│           └── (placeholder)
├── tests/
│   ├── conftest.py                    # Pytest fixtures
│   ├── test_integration.py            # Cross-subsystem tests
│   └── test_compliance.py             # Enterprise quality gates
├── docs/
│   ├── architecture.md
│   ├── phase-0-kernel.md
│   ├── phase-1-protocols.md
│   ├── phase-2-orchestrator.md
│   └── phase-3-agents.md
├── .github/
│   ├── workflows/
│   │   ├── tests.yml
│   │   ├── lint.yml
│   │   └── security.yml
│   ├── instructions/
│   │   └── (references /workspaces/agents/config/python/)
│   └── AGENTS.md (symlink to /workspaces/agents/AGENTS.md)
├── .agent-state/
│   ├── phase-0-checkpoints.jsonl
│   ├── phase-1-checkpoints.jsonl
│   ├── phase-2-checkpoints.jsonl
│   └── phase-3-checkpoints.jsonl
└── .gitignore
```

---

## Phase 0: Harness Kernel

**Objective**: Build the runtime control plane that enforces all policy defined in `/workspaces/agents/AGENTS.md`.

**Duration**: 3–4 weeks  
**Acceptance Criteria**:
- ✅ All 5 subsystems implemented and tested (state, validation, worktree, audit, gateway)
- ✅ ≥90% test coverage
- ✅ All security checks pass (bandit, safety)
- ✅ All deterministic rails pass
- ✅ Audit trail hash-chained and verified
- ✅ Checkout to `main`; tag as `v0.1.0`

### Phase 0.1: StateManager (Week 1)

**Objective**: Implement state persistence and progressive disclosure.

**Checkpoint**: `CKPT-0.1-StateManager-Core`

#### Deliverables

1. **src/agents_harness/state/models.py**
   - Pydantic models for:
     - `AgentState`: Top-level state container
     - `PhaseState`: Phase-specific state (checkpoint, deliverables, tests passed)
     - `ProgressiveDisclosure`: Lazy-loaded context layers (summary → detailed → full)
     - `AuditEntry`: State change record (timestamp, actor, change, hash)

2. **src/agents_harness/state/manager.py**
   - `StateManager` class:
     - `load_from_agents_md()`: Parse `/workspaces/agents/AGENTS.md` as source of truth
     - `load_phase_state(phase: int)`: Load state for specific phase from `.agent-state/`
     - `save_phase_state(phase: int, state: PhaseState)`: Persist phase state with hash
     - `get_progressive_disclosure(layer: int)`: Return context at specific detail level
     - `update_checkpoint(phase: int, checkpoint_name: str)`: Record completed checkpoint
     - `query_skill(skill_name: str)`: Look up skill metadata from AGENTS.md
     - `resume_from_checkpoint(tag: str)`: Load state from Git tag

3. **src/agents_harness/state/tests/test_manager.py**
   - Test AGENTS.md parsing
   - Test state persistence and recovery
   - Test progressive disclosure (verify context layers)
   - Test checkpoint updates with hash verification
   - Test recovery from missing state file (should regenerate from AGENTS.md)

#### Implementation Details

```python
# src/agents_harness/state/manager.py (pseudocode structure)
import json
import hashlib
from pathlib import Path
from datetime import datetime
from pydantic import BaseModel

class StateManager:
    """
    Manages state persistence and progressive disclosure.
    
    Attributes:
        agents_md_path: Path to /workspaces/agents/AGENTS.md
        state_dir: Path to /workspaces/agents/.agent-state/
        current_phase: Current phase (0-3)
    """
    
    def __init__(self, agents_md_path: Path, state_dir: Path):
        self.agents_md_path = agents_md_path
        self.state_dir = state_dir
        self.state_dir.mkdir(parents=True, exist_ok=True)
        
    def load_from_agents_md(self) -> dict:
        """Parse AGENTS.md and extract state schema."""
        # Read AGENTS.md, extract frontmatter, return as dict
        
    def load_phase_state(self, phase: int) -> PhaseState:
        """Load phase state from .agent-state/phase-{phase}-checkpoints.jsonl."""
        # Read JSONL, return last non-deleted entry
        
    def save_phase_state(self, phase: int, state: PhaseState) -> None:
        """Persist phase state with hash chaining."""
        # Compute sha256(prev_state + current_state)
        # Append to phase-{phase}-checkpoints.jsonl
        # Update current_checkpoint.txt
        
    def get_progressive_disclosure(self, layer: int) -> dict:
        """Return context at specific detail level (1=summary, 5=full)."""
        # Limit returned state by layer depth
        
    def update_checkpoint(self, phase: int, checkpoint_name: str, artifacts: dict) -> None:
        """Record completed checkpoint."""
        # Save checkpoint entry with status=Complete, timestamp, artifacts
```

#### Acceptance Criteria for 0.1

- ✅ `StateManager` reads AGENTS.md without errors
- ✅ State can be written to and read from `.agent-state/` without data loss
- ✅ Progressive disclosure returns correct layers
- ✅ Hash chaining is verified (sha256(prev) == computed_hash)
- ✅ Recovery from missing state file succeeds (regenerates from AGENTS.md)
- ✅ Test coverage ≥90%
- ✅ `mypy` passes with strict mode

#### Rollback Procedure (0.1)

```bash
# If StateManager tests fail:
git checkout HEAD -- src/agents_harness/state/
rm -rf /workspaces/agents/.agent-state/phase-0-checkpoints.jsonl
# Or revert to prior checkpoint tag:
git reset --hard vX.Y.Z-CKPT-0.0-PrePhase
```

#### Tag & Commit

```bash
git add src/agents_harness/state/
git commit -m "Phase 0.1: StateManager core implementation

- Implemented StateManager with progressive disclosure
- Added Pydantic models for state persistence
- Hash chaining for audit trail
- Recovery procedures from missing state

Checkpoint: CKPT-0.1-StateManager-Core
Coverage: 92%
Status: Complete"

git tag -a v0.1.0-CKPT-0.1-StateManager-Core \
  -m "Phase: 0; Checkpoint: StateManager (core); Status: Complete; Date: $(date -u +%Y-%m-%dT%H:%M:%SZ); Milestone: State persistence & progressive disclosure"
```

#### Audit Log Entry

```json
{
  "sequence": 1,
  "timestamp": "2026-04-26T14:32:00Z",
  "phase": 0,
  "checkpoint": "CKPT-0.1-StateManager-Core",
  "actor": "Agent-Copilot",
  "action": "Complete",
  "subsystem": "StateManager",
  "deliverables": ["state/models.py", "state/manager.py", "state/tests/test_manager.py"],
  "tests_passed": 45,
  "coverage": "92%",
  "security_checks": "passed",
  "status": "Complete",
  "artifacts": {
    "test_report": "tests/evidence/phase-0.1-test-report.html",
    "coverage_report": "tests/evidence/phase-0.1-coverage.html"
  },
  "hash": "sha256(prev_entry + current_entry)"
}
```

---

### Phase 0.2: ValidationMiddleware (Week 2)

**Objective**: Implement deterministic validation rails that block non-compliant outputs.

**Checkpoint**: `CKPT-0.2-ValidationMiddleware-Core`

#### Deliverables

1. **src/agents_harness/validation/models.py**
   - Pydantic models for:
     - `ValidationRule`: A single rule (tool name, error code, severity)
     - `ValidationResult`: Outcome of running a validation (passed, failed, warnings)
     - `ValidationConfig`: Configuration (which tools to run, thresholds)

2. **src/agents_harness/validation/middleware.py**
   - `ValidationMiddleware` class:
     - `validate_code(code: str, file_path: str)`: Run all validators against code
     - `validate_all()`: Run all validators against entire codebase
     - Orchestrates ruff, mypy, pytest, interrogate, boundary checker
     - Returns aggregated `ValidationResult` with blocking errors and warnings

3. **src/agents_harness/validation/ruff_runner.py**
   - `RuffRunner` class:
     - Executes `ruff check` against code
     - Parses output, maps to `ValidationResult`
     - Threshold: 0 blocking errors (E errors block, W warnings do not)

4. **src/agents_harness/validation/mypy_runner.py**
   - `MypyRunner` class:
     - Executes `mypy --strict` against code
     - Threshold: 0 errors

5. **src/agents_harness/validation/pytest_runner.py**
   - `PytestRunner` class:
     - Executes `pytest` with coverage threshold
     - Threshold: ≥90% coverage

6. **src/agents_harness/validation/interrogate_runner.py**
   - `InterrogateRunner` class:
     - Executes `interrogate` for docstring coverage
     - Threshold: ≥90% docstring coverage

7. **src/agents_harness/validation/boundary_checker.py**
   - `BoundaryChecker` class (AST-based):
     - Parses Python AST to enforce layer model from enterprise-python-checklist.md
     - Enforces: config → models → services → api (acyclic dependencies)
     - Detects cross-layer violations (e.g., api module importing from services)
     - Threshold: 0 violations

8. **src/agents_harness/validation/tests/**
   - Unit tests for each runner
   - Integration test: `validate_code()` with malformed code (should fail)
   - Integration test: `validate_code()` with compliant code (should pass)

#### Implementation Details

```python
# src/agents_harness/validation/middleware.py (pseudocode)
class ValidationMiddleware:
    """
    Deterministic validation gates that physically block non-compliant outputs.
    """
    
    def __init__(self, config: ValidationConfig):
        self.ruff_runner = RuffRunner()
        self.mypy_runner = MypyRunner()
        self.pytest_runner = PytestRunner()
        self.interrogate_runner = InterrogateRunner()
        self.boundary_checker = BoundaryChecker()
        
    def validate_code(self, code: str, file_path: str) -> ValidationResult:
        """Validate single code file. Fail-fast on blocking errors."""
        results = []
        
        # Run each validator
        for runner in [self.ruff_runner, self.mypy_runner, self.boundary_checker]:
            result = runner.run(code, file_path)
            if result.has_blocking_errors:
                result.status = "FAILED"
                return result  # Fail fast
            results.append(result)
            
        # Aggregate results
        return self._aggregate_results(results)
        
    def validate_all(self) -> ValidationResult:
        """Validate entire codebase."""
        # Run pytest, interrogate, coverage checks
        # Return aggregated result
        
    def _aggregate_results(self, results: list[ValidationResult]) -> ValidationResult:
        """Combine results from multiple validators."""
        # Return FAILED if any blocking error
        # Return WARNINGS if only warnings
        # Return PASSED if clean
```

#### Acceptance Criteria for 0.2

- ✅ All validators (ruff, mypy, pytest, interrogate, boundary_checker) implemented and callable
- ✅ Middleware correctly aggregates results and fails fast on blocking errors
- ✅ Boundary checker detects layer violations in AST
- ✅ Test coverage ≥90%
- ✅ Passing `mypy --strict`

#### Rollback Procedure (0.2)

```bash
git reset --hard v0.1.0-CKPT-0.1-StateManager-Core
```

#### Tag & Commit

```bash
git add src/agents_harness/validation/
git commit -m "Phase 0.2: ValidationMiddleware implementation

- Integrated ruff, mypy, pytest, interrogate
- Implemented AST-based boundary checker
- Fail-fast middleware orchestration
- All validators enforce enterprise quality bar

Checkpoint: CKPT-0.2-ValidationMiddleware-Core
Coverage: 91%
Status: Complete"

git tag -a v0.2.0-CKPT-0.2-ValidationMiddleware-Core \
  -m "Phase: 0; Checkpoint: ValidationMiddleware (core); Status: Complete; Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
```

---

### Phase 0.3: WorktreeManager (Week 2–3)

**Objective**: Implement Git worktree provisioning and cleanup.

**Checkpoint**: `CKPT-0.3-WorktreeManager-Core`

#### Deliverables

1. **src/agents_harness/worktree/models.py**
   - Pydantic models for:
     - `WorktreeConfig`: Configuration (base repo, isolation strategy)
     - `WorktreeTask`: Task metadata (task_id, branch_name, agent, created_at, expires_at)
     - `WorktreeSnapshot`: Saved state of a worktree (HEAD commit, uncommitted changes)

2. **src/agents_harness/worktree/manager.py**
   - `WorktreeManager` class:
     - `create_worktree(task: WorktreeTask) -> WorktreeSnapshot`: Create isolated git worktree
     - `clean_worktree(task_id: str)`: Remove worktree and cleanup
     - `list_active_worktrees()`: List all current worktrees
     - `auto_cleanup_expired(ttl_hours: int = 24)`: Remove stale worktrees
     - `verify_isolation(task_id: str)`: Ensure worktree is isolated

3. **src/agents_harness/worktree/tests/**
   - Test worktree creation and cleanup
   - Test isolation (changes in worktree don't affect main)
   - Test auto-cleanup
   - Test recovery from failed cleanup

#### Implementation Details

```python
# src/agents_harness/worktree/manager.py (pseudocode)
class WorktreeManager:
    """
    Manages ephemeral, isolated Git worktrees per agent task.
    """
    
    def __init__(self, repo_root: Path, task_dir: Path):
        self.repo_root = repo_root
        self.task_dir = task_dir  # e.g., /workspaces/agents/.agent-state/tasks/
        self.task_dir.mkdir(parents=True, exist_ok=True)
        
    def create_worktree(self, task: WorktreeTask) -> WorktreeSnapshot:
        """Create isolated Git worktree for task."""
        worktree_path = self.task_dir / task.task_id
        branch_name = task.branch_name or f"task-{task.task_id}"
        
        # git worktree add --detach <path> main
        subprocess.run(
            ["git", "worktree", "add", "--detach", str(worktree_path), "main"],
            cwd=self.repo_root,
            check=True
        )
        
        # Create branch
        subprocess.run(
            ["git", "checkout", "-b", branch_name],
            cwd=worktree_path,
            check=True
        )
        
        # Record in .agent-state/tasks.jsonl
        # Return snapshot with HEAD, task metadata
        
    def clean_worktree(self, task_id: str) -> None:
        """Remove worktree and cleanup."""
        worktree_path = self.task_dir / task_id
        
        # git worktree remove <path>
        subprocess.run(
            ["git", "worktree", "remove", str(worktree_path)],
            cwd=self.repo_root,
            check=True
        )
        
    def verify_isolation(self, task_id: str) -> bool:
        """Verify worktree is truly isolated."""
        worktree_path = self.task_dir / task_id
        main_status = subprocess.run(
            ["git", "status", "--porcelain"],
            cwd=self.repo_root,
            capture_output=True
        ).stdout.decode()
        worktree_status = subprocess.run(
            ["git", "status", "--porcelain"],
            cwd=worktree_path,
            capture_output=True
        ).stdout.decode()
        # Both should be clean or independent
        return len(main_status) == 0 or len(worktree_status) == 0
```

#### Acceptance Criteria for 0.3

- ✅ Worktree creation and cleanup work without errors
- ✅ Worktrees are isolated (main branch unaffected by worktree changes)
- ✅ Auto-cleanup removes stale worktrees
- ✅ Cleanup recovery handles partial/failed removals
- ✅ Test coverage ≥90%

---

### Phase 0.4: AuditLogger (Week 3)

**Objective**: Implement hash-chained, append-only audit log.

**Checkpoint**: `CKPT-0.4-AuditLogger-Core`

#### Deliverables

1. **src/agents_harness/audit/models.py**
   - Pydantic models for:
     - `AuditEntry`: Single log entry (timestamp, actor, action, resource, result, hash)
     - `HashChain`: Verify hash chain integrity (compute sha256(prev_entry + current_entry))

2. **src/agents_harness/audit/logger.py**
   - `AuditLogger` class:
     - `log_entry(entry: AuditEntry) -> None`: Append entry to execution.jsonl with hash
     - `verify_chain() -> bool`: Verify hash chain from first to last entry
     - `get_entries(filter: str = "") -> list[AuditEntry]`: Query entries (regex filter)
     - `create_immutable_snapshot()`: Create hash-locked snapshot (used for compliance export)

3. **src/agents_harness/audit/tests/**
   - Test append-only property (cannot delete or edit entries)
   - Test hash verification (detect tampering)
   - Test recovery from corrupted entry

#### Implementation Details

```python
# src/agents_harness/audit/logger.py (pseudocode)
class AuditLogger:
    """
    Hash-chained, append-only audit log for compliance and debugging.
    """
    
    def __init__(self, log_path: Path):
        self.log_path = log_path
        self.log_path.touch(exist_ok=True)
        
    def log_entry(self, entry: AuditEntry) -> None:
        """Append entry with hash chain."""
        # Read last entry, compute prev_hash
        prev_hash = self._get_last_hash()
        
        # Compute current hash: sha256(prev_hash + entry_json)
        entry_json = entry.model_dump_json()
        current_hash = hashlib.sha256(
            f"{prev_hash}{entry_json}".encode()
        ).hexdigest()
        
        # Update entry with hash
        entry.prev_hash = prev_hash
        entry.hash = current_hash
        
        # Append to JSONL
        with open(self.log_path, "a") as f:
            f.write(entry.model_dump_json() + "\n")
            
    def verify_chain(self) -> bool:
        """Verify hash chain integrity."""
        with open(self.log_path, "r") as f:
            lines = f.readlines()
            
        prev_hash = "0" * 64  # Genesis hash
        for line in lines:
            entry = AuditEntry(**json.loads(line))
            # Compute expected hash
            expected = hashlib.sha256(
                f"{prev_hash}{entry.to_json_no_hash()}".encode()
            ).hexdigest()
            if expected != entry.hash:
                return False
            prev_hash = entry.hash
        return True
```

#### Acceptance Criteria for 0.4

- ✅ Entries are append-only (cannot be edited or deleted)
- ✅ Hash chain is verified (tampering is detected)
- ✅ Recovery from missing entry fails with clear error
- ✅ Test coverage ≥90%

---

### Phase 0.5: ToolGateway (Week 3–4)

**Objective**: Implement tool invocation gateway with schema validation and loop detection.

**Checkpoint**: `CKPT-0.5-ToolGateway-Core`

#### Deliverables

1. **src/agents_harness/gateway/models.py**
   - Pydantic models for:
     - `ToolRequest`: Inbound tool call (tool_name, args, kwargs, context)
     - `ToolResponse`: Outbound tool result (status, result, errors)
     - `ToolSchema`: Tool metadata (name, inputs, outputs, rate_limit)
     - `LoopEvent`: Detected loop (same tool called N times in M seconds)

2. **src/agents_harness/gateway/gateway.py**
   - `ToolGateway` class:
     - `invoke_tool(request: ToolRequest) -> ToolResponse`: Invoke tool with validation
     - `register_tool(schema: ToolSchema) -> None`: Register tool schema
     - `validate_request(request: ToolRequest) -> bool`: Schema validation
     - `detect_loops() -> list[LoopEvent]`: Detect repetitive tool calls

3. **src/agents_harness/gateway/loop_detector.py**
   - `LoopDetector` class:
     - Track tool invocations (timestamp, tool_name, hash of args)
     - Detect pattern: same tool with same args called N times in M seconds
     - Threshold: Fail closed if >5 identical calls in 60 seconds

4. **src/agents_harness/gateway/tests/**
   - Test tool invocation with valid request (should succeed)
   - Test tool invocation with invalid schema (should fail)
   - Test loop detection (should trigger after N identical calls)

#### Implementation Details

```python
# src/agents_harness/gateway/gateway.py (pseudocode)
class ToolGateway:
    """
    Validates and routes tool invocations; detects and prevents loops.
    """
    
    def __init__(self):
        self.tools: dict[str, ToolSchema] = {}
        self.loop_detector = LoopDetector()
        self.audit_logger = AuditLogger(...)
        
    def register_tool(self, schema: ToolSchema) -> None:
        """Register tool schema."""
        self.tools[schema.name] = schema
        
    def invoke_tool(self, request: ToolRequest) -> ToolResponse:
        """Invoke tool with validation and loop detection."""
        # 1. Validate request against schema
        if not self.validate_request(request):
            return ToolResponse(status="FAILED", errors=["Invalid schema"])
            
        # 2. Check for loops
        if self.loop_detector.detect_loop(request):
            self.audit_logger.log_entry(
                AuditEntry(action="LoopDetected", tool=request.tool_name)
            )
            return ToolResponse(
                status="FAILED",
                errors=["Loop detected; execution halted"]
            )
            
        # 3. Invoke tool
        try:
            result = self.tools[request.tool_name].invoke(**request.kwargs)
            return ToolResponse(status="SUCCESS", result=result)
        except Exception as e:
            return ToolResponse(status="FAILED", errors=[str(e)])
            
    def validate_request(self, request: ToolRequest) -> bool:
        """Validate request against registered tool schema."""
        schema = self.tools.get(request.tool_name)
        if not schema:
            return False
        # Use Pydantic to validate args/kwargs against schema inputs
        try:
            schema.input_model(**request.kwargs)
            return True
        except Exception:
            return False
```

#### Acceptance Criteria for 0.5

- ✅ Tool registration and invocation work
- ✅ Schema validation blocks invalid requests
- ✅ Loop detection triggers after N identical calls
- ✅ Test coverage ≥90%

---

### Phase 0 Final Integration & Testing

**Objective**: Verify all 5 subsystems work together; run full compliance check.

#### Tasks

1. **Integration Test: End-to-End Workflow**
   ```python
   # Test: agent runs through a full cycle
   # 1. StateManager loads AGENTS.md
   # 2. Agent generates code
   # 3. ValidationMiddleware validates code (fails intentionally)
   # 4. Agent fixes code
   # 5. ValidationMiddleware validates again (passes)
   # 6. ToolGateway invokes Git commit tool (safe worktree)
   # 7. AuditLogger records all steps
   # 8. Verify hash chain integrity
   ```

2. **Compliance Check**
   ```bash
   pytest tests/ --cov=src/agents_harness --cov-fail-under=90
   mypy src/agents_harness --strict
   bandit -r src/agents_harness
   safety check
   interrogate -vv src/agents_harness --fail-under 90
   ```

3. **Rollback Test**
   - Simulate session failure at each checkpoint
   - Verify recovery from saved state

#### Acceptance Criteria for Phase 0

- ✅ All 5 subsystems integrated and tested
- ✅ End-to-end workflow passes
- ✅ Coverage ≥90%
- ✅ All security checks pass
- ✅ Audit chain verified
- ✅ Rollback procedures tested and documented

#### Final Tag

```bash
git tag -a v0.5.0-Phase-0-Complete \
  -m "Phase: 0 (Harness Kernel); Status: Complete; Date: $(date -u +%Y-%m-%dT%H:%M:%SZ); Milestone: All 5 subsystems complete, tested, and integrated"
```

---

---

## External Dependencies & Build vs. Reuse Strategy

**Objective**: Establish a "no wheel reinvention" principle by auditing existing MCP servers, agents, and frameworks; decide build vs. reuse for each component.

**Key Principle**: Use well-documented, community-maintained, production-grade external dependencies whenever they meet requirements. Build custom integrations only for harness-specific logic or when no suitable external option exists.

### Existing MCP Servers to Reuse

These are production-ready, well-documented MCP servers maintained by Anthropic or trusted communities. **Do NOT build custom versions of these**.

| MCP Server | Purpose | Maintainer | Status | Integration Point | Notes |
|------------|---------|------------|--------|-------------------|-------|
| **MCP Git** | Git operations (clone, commit, push, branch, worktree) | Anthropic Official | ✅ Stable | Phase 1.1 | Use directly; wrap in ToolGateway for validation & audit logging only |
| **MCP Filesystem** | File read/write/list with sandbox isolation | Anthropic Official | ✅ Stable | Phase 1.2 | Use directly; add permission checks in wrapper |
| **MCP Web Fetch** | Fetch and parse web content (HTML, JSON, etc.) | Anthropic Official | ✅ Stable | Phase 1 extension | Use for documentation scraping, API exploration |
| **MCP Fetch (Claude CLI)** | HTTP requests, file downloads | Anthropic Official | ✅ Stable | Phase 1 extension | Use for API calls, external data fetches |
| **MCP Process** | Execute shell commands in sandboxed environment | Anthropic Official | ✅ Stable | Phase 1 extension | Use for linting, testing, build commands (with restrictions) |
| **MCP Python REPL** | Execute Python code safely | Anthropic Official | ✅ Stable | Phase 1 extension | Use for code generation validation, dynamic schema inference |
| **MCP GitHub** | GitHub API (issues, PRs, repos, workflows) | Anthropic Official | ✅ Stable | Phase 3 extension | Use for PR automation, repo metadata queries |
| **MCP Jira** | Jira API (tickets, projects, workflows) | Anthropic Community | ✅ Stable | Phase 3 extension | Use for task linking, milestone tracking |
| **MCP Database (SQLite/PostgreSQL)** | Query and modify databases | Anthropic Community | ✅ Stable | Phase 3 extension | Use if persisting state to database (currently not needed; JSONL sufficient) |

### Existing Frameworks & Libraries to Reuse

These are production-grade frameworks for orchestration, security, and specialized agents.

| Framework | Purpose | Use Case | Status | Integration Point | Decision |
|-----------|---------|----------|--------|-------------------|----------|
| **MetaGPT** | Multi-agent orchestration with pre-built roles (Architect, Engineer, QA, PM) | Orchestrator; role-based task delegation | ✅ Production | Phase 2 | **USE**: Aligns perfectly with AGENTS.md's role-based design. Saves 2+ weeks. |
| **LangGraph** | Graph-based agent orchestration with human-in-the-loop | Alternative orchestrator; fine-grained routing | ✅ Production | Phase 2 | **USE IF** MetaGPT's SOP model is too rigid; provides more control. |
| **Anthropic Claude SDK (Python)** | Native integration with Claude models | All agent reasoning | ✅ Production | All Phases | **USE**: Official SDK; ship-safe integrations. |
| **Ship Safe (Security Agent)** | Multi-specialist security scanning (SAST, secrets, injection, auth) | Phase 3.1 Security Agent reference | ✅ Production | Phase 3.1 | **STUDY & ADAPT**: Don't reinvent; model security agent after Ship Safe architecture. |
| **Pydantic v2** | Type-safe configuration & validation | Input validation, schema generation | ✅ Production | All Phases | **USE**: Mandatory for enterprise quality bar. |
| **Pytest + Pytest-Asyncio** | Testing framework with async support | All test suites | ✅ Production | All Phases | **USE**: Pinned versions (pytest ≥8.0, pytest-asyncio ≥0.24,<1.0). |
| **Ruff** | Fast Python linter & formatter | Code quality gates | ✅ Production | Phase 0.2 | **USE**: Replaces Black + Flake8 + isort; 100x faster. |
| **Mypy** | Static type checker (strict mode) | Type safety enforcement | ✅ Production | Phase 0.2 | **USE**: Enforced with --strict; non-negotiable. |
| **Bandit** | Security linting (find common vulnerabilities) | Security checks | ✅ Production | Phase 0 tests | **USE**: Blocks HIGH/CRITICAL issues in CI. |
| **Interrogate** | Docstring coverage enforcement | Documentation gates | ✅ Production | Phase 0.2 | **USE**: ≥90% coverage threshold. |
| **Slowapi** | Rate limiting middleware (FastAPI) | Rate limiting enforcement | ✅ Production | Services (Phase 3+) | **USE**: Integrates with FastAPI; standard choice. |

### Build vs. Reuse Decision Matrix

Use this matrix to decide whether to build custom code or reuse existing components:

| Decision Criteria | Build | Reuse |
|------------------|-------|-------|
| **Existing solution available & well-documented?** | No → Build | Yes → Reuse |
| **Used in production by trusted orgs?** | No → Build | Yes → Reuse |
| **Requires harness-specific customization?** | Yes → Build wrapper | No → Use directly or thin wrapper |
| **Security implications if wrong?** | High → Build in-house | Low → Reuse with audit |
| **Active maintenance & support?** | No → Build | Yes → Reuse |
| **License compatible?** | No → Build | Yes → Reuse |
| **Learning curve / time to productivity** | High → Evaluate reuse first | Low → Reuse faster |

**Decision Rule**: Default to REUSE. Build only when the matrix clearly shows "Build" criteria.

### Phase 1 Updated: Protocol Adapters (Build vs. Reuse)

| Phase 1 Task | Decision | Implementation |
|--------------|----------|-----------------|
| **1.1: Git Operations** | ✅ REUSE | Use Anthropic's official MCP Git server directly; wrap in ToolGateway for audit logging and loop detection only. No custom Git implementation. |
| **1.2: Filesystem Operations** | ✅ REUSE | Use Anthropic's official MCP Filesystem server; add permission checks and sandboxing in wrapper. No custom file I/O implementation. |
| **1.3: Validation Server** | ⚠️ BUILD | Custom MCP server wrapping ValidationMiddleware (ruff, mypy, pytest, interrogate, boundary checker) — this is harness-specific and has no direct external equivalent. However, each underlying tool (ruff, mypy) is external; we just orchestrate them via MCP. |
| **1.4: Audit Server** | ⚠️ BUILD | Custom MCP server wrapping AuditLogger (hash-chained logging) — this is harness-specific. No production equivalent exists (audit logs are usually proprietary to each system). |
| **1.5: Process Execution** | ✅ REUSE | Use Anthropic's official MCP Process server for shell command execution (testing, linting, builds). Sandboxed; safe for agent use. |
| **1.6: Web Fetch (Future)** | ✅ REUSE | Use Anthropic's MCP Web Fetch server for documentation scraping, API exploration. Don't build HTTP client from scratch. |

### Integration Strategy: Using External MCP Servers

When integrating external MCP servers (e.g., Anthropic's MCP Git):

1. **Install via uv**:
   ```bash
   uv pip install mcp-git  # or equivalent
   ```

2. **Wrap in ToolGateway**:
   ```python
   # src/agents_harness/gateway/wrappers/git_wrapper.py
   class GitToolWrapper:
       """Wraps external MCP Git server; adds audit logging and validation."""
       
       def __init__(self, mcp_git_client):
           self.git = mcp_git_client
           self.audit_logger = AuditLogger(...)
           
       def invoke(self, tool_name: str, args: dict) -> dict:
           """Invoke external MCP tool with audit trail."""
           # 1. Validate request
           # 2. Call self.git.<tool_name>(**args)
           # 3. Log to audit trail
           # 4. Return result
   ```

3. **Register in ToolGateway**:
   ```python
   gateway = ToolGateway()
   git_wrapper = GitToolWrapper(mcp_git_client)
   gateway.register_tool(
       ToolSchema(name="git_commit", wrapper=git_wrapper, ...)
   )
   ```

### Phase 1 Revised: Adapt for External Servers

**New Phase 1 Structure**:

- **1.0: Inventory External MCP Servers** (Day 1)
  - Audit Anthropic's official MCP servers; test compatibility with Python SDK
  - Document which servers are available and stable
  - Create decision table: "Use Anthropic MCP" vs. "Build custom"
  - Deliverable: `docs/external-mcp-inventory.md` and `pyproject.toml` with MCP dependencies

- **1.1: Integrate External MCP Servers** (Days 2–3)
  - Add Anthropic MCP servers to `pyproject.toml` (git, filesystem, process, web-fetch)
  - Test that external servers work with harness StateManager
  - Deliverable: Working MCP clients for each external server

- **1.2: Build Custom MCP Wrappers** (Days 4–5)
  - Build MCP Validation Server (wraps ValidationMiddleware)
  - Build MCP Audit Server (wraps AuditLogger)
  - Build thin wrappers for external servers (add audit logging, loop detection, etc.)
  - Deliverable: All custom and wrapper MCP servers operational

- **1.3: Integration Testing** (Days 6–7)
  - Test all MCP servers (external + custom) together
  - Verify ToolGateway can invoke all servers
  - Verify audit trail captures all invocations
  - Deliverable: Integration tests pass; Phase 2 ready

### Dependencies Management: pyproject.toml

Add all external MCP servers to `pyproject.toml`:

```toml
# /workspaces/agents-harness/pyproject.toml

[project]
dependencies = [
    "pydantic>=2.8.0",
    "pytest>=8.0.0",
    "pytest-asyncio>=0.24.0,<1.0",
    "mypy>=1.11.0",
    "ruff>=0.5.0",
    "bandit>=1.7.0",
    "interrogate>=1.5.0",
    
    # MCP Servers (Anthropic Official)
    "mcp-git>=0.1.0",          # Git operations
    "mcp-filesystem>=0.1.0",   # File operations
    "mcp-process>=0.1.0",      # Shell execution
    "mcp-web>=0.1.0",          # Web fetching
    "mcp-github>=0.1.0",       # GitHub API (for Phase 3)
    
    # Orchestration Frameworks
    "metagpt>=0.6.0",          # Multi-agent orchestration
    "langgraph>=0.1.0",        # Graph-based routing (optional)
    
    # SDK & Core
    "anthropic>=0.25.0",       # Claude SDK
]
```

### Verification Checklist: Phase 1 Pre-Execution

Before starting Phase 1, verify:

- [ ] Anthropic MCP Git server tested and working with Python SDK
- [ ] Anthropic MCP Filesystem server tested and working
- [ ] Anthropic MCP Process server available and tested
- [ ] Decision matrix completed for all Phase 1 tasks
- [ ] `pyproject.toml` includes all external MCP dependencies (pinned versions)
- [ ] MetaGPT available and tested (Phase 2 prerequisite)
- [ ] All external servers documented in `docs/external-mcp-inventory.md`
- [ ] No attempt to build custom Git, filesystem, or process servers (use external)

---

## Phase 1: Protocol Adapters

**Objective**: Integrate existing external MCP servers first, then implement only harness-specific custom wrappers to eliminate N×M integration tax.

**Duration**: 1 week  
**Dependencies**: Phase 0 complete and tagged  
**Acceptance Criteria**:

### Phase 1 Execution Model

The authoritative Phase 1 flow starts below at `Phase 1.0` and follows the reuse-first sequence:

1. Inventory and verify external MCP servers.
2. Integrate external MCP servers through wrappers.
3. Build only harness-specific custom MCP services.
4. Validate integrated behavior end-to-end.

### Phase 1.0: Inventory & Pre-Execution Verification

**Checkpoint**: `CKPT-1.0-MCP-Inventory-Complete`

#### Tasks

1. **Audit Anthropic's Official MCP Servers**
   - Test mcp-git, mcp-filesystem, mcp-process servers for compatibility
   - Verify Python SDK integration
   - Document capabilities and limitations
   - Deliverable: `docs/external-mcp-inventory.md`

2. **Create pyproject.toml with External Dependencies**
   - Add all external MCP servers (pinned versions)
   - Add MetaGPT for Phase 2 prerequisite
   - Add all required testing & validation tools
   - Deliverable: `/workspaces/agents-harness/pyproject.toml`

3. **Test External MCP Servers**
   - Run mcp-git in isolation (test commit, push, worktree)
   - Run mcp-filesystem in isolation (test read, write, list)
   - Run mcp-process in isolation (test safe command execution)
   - Deliverable: Integration tests for each external server

#### Acceptance Criteria for 1.0

- ✅ All external MCP servers tested and working
- ✅ Decision matrix (Build vs. Reuse) completed and reviewed
- ✅ `pyproject.toml` locked via `uv.lock`
- ✅ Pre-execution verification checklist signed off

---

### Phase 1.1: Integrate External MCP Servers

**Checkpoint**: `CKPT-1.1-External-MCP-Integrated`

#### Deliverable

Create wrappers that integrate external MCP servers into ToolGateway:

```python
# src/agents_harness/gateway/wrappers/external_mcp_wrapper.py
class ExternalMCPWrapper:
  """Wraps external Anthropic MCP servers; adds audit logging."""
    
  def __init__(self, mcp_server_client, audit_logger):
    self.mcp_client = mcp_server_client
    self.audit_logger = audit_logger
        
  async def invoke(self, tool_name: str, args: dict) -> dict:
    """Invoke external MCP tool with audit trail."""
    # 1. Log invocation
    self.audit_logger.log_entry(
      AuditEntry(action="MCP_Invoke", tool=tool_name, args=args)
    )
        
    # 2. Call external MCP server
    result = await self.mcp_client.call_tool(tool_name, args)
        
    # 3. Log result
    self.audit_logger.log_entry(
      AuditEntry(action="MCP_Result", tool=tool_name, status="Success")
    )
        
    return result
```

#### Tasks

1. **Create GitMCPWrapper** (wraps mcp-git)
2. **Create FilesystemMCPWrapper** (wraps mcp-filesystem)
3. **Create ProcessMCPWrapper** (wraps mcp-process)
4. **Register all wrappers in ToolGateway**
5. **Test each wrapper in isolation**

#### Acceptance Criteria for 1.1

- ✅ All external MCP wrappers callable via ToolGateway
- ✅ Audit trail captures all invocations
- ✅ Test coverage ≥90% for wrapper code (not external MCP code)
- ✅ Loop detection works (detects repeated calls to same tool)

---

### Phase 1.2: Build Custom MCP Servers

**Checkpoint**: `CKPT-1.2-Custom-MCP-Servers`

#### Deliverables

Build only what doesn't exist externally:

1. **MCP Validation Server**
   ```python
   # src/agents_harness/mcp/validation_server.py
   class ValidationMCPServer:
     """MCP server wrapping ValidationMiddleware."""
       
     async def validate_code(self, code: str, file_path: str) -> dict:
       """Validate code against all rails (ruff, mypy, pytest, etc.)."""
       return self.middleware.validate_code(code, file_path)
       
     async def validate_all(self) -> dict:
       """Run full validation on codebase."""
       return self.middleware.validate_all()
   ```

2. **MCP Audit Server**
   ```python
   # src/agents_harness/mcp/audit_server.py
   class AuditMCPServer:
     """MCP server wrapping AuditLogger."""
       
     async def log_entry(self, entry: dict) -> dict:
       """Log audit entry."""
       return self.logger.log_entry(AuditEntry(**entry))
       
     async def verify_chain(self) -> dict:
       """Verify hash chain integrity."""
       return {"valid": self.logger.verify_chain()}
       
     async def query_entries(self, filter: str = "") -> dict:
       """Query audit entries."""
       return {"entries": self.logger.get_entries(filter)}
   ```

#### Acceptance Criteria for 1.2

- ✅ Validation MCP Server callable and returns correct results
- ✅ Audit MCP Server callable and returns correct results
- ✅ Test coverage ≥90%
- ✅ Integration with ToolGateway works

---

### Phase 1.3: Integration Testing

**Checkpoint**: `CKPT-1.3-MCP-Integration-Complete`

#### Tasks

1. **Test End-to-End MCP Workflow**
   ```python
   # tests/test_mcp_integration.py
   async def test_mcp_git_workflow():
     """Test Git operations via MCP."""
     # 1. Create worktree via MCP Git
     # 2. Write file via MCP Filesystem
     # 3. Validate file via MCP Validation
     # 4. Commit via MCP Git
     # 5. Verify audit trail captured all steps
   ```

2. **Test Loop Detection**
   ```python
   async def test_mcp_loop_detection():
     """Test that ToolGateway detects repeated MCP calls."""
     # Invoke same MCP tool N times in M seconds
     # Verify loop detection triggers
     # Verify audit trail logs LoopDetected event
   ```

3. **Test Error Handling**
   - Invalid MCP input (schema violation)
   - External MCP server timeout
   - Audit server failure (hash chain corruption)

#### Acceptance Criteria for 1.3

- ✅ All MCP integration tests pass
- ✅ Loop detection triggers correctly
- ✅ Error handling is graceful
- ✅ Audit trail is complete and valid

---

### Phase 1 Final Integration & Testing

**Final Tag**: `v1.0.0-Phase-1-Complete`

**Verification**:
- ✅ All external MCP servers working (Git, Filesystem, Process)
- ✅ All custom MCP servers working (Validation, Audit)
- ✅ ToolGateway can invoke all servers with audit logging
- ✅ Loop detection prevents runaway invocations
- ✅ Coverage ≥90% for custom code (external code has own coverage)
- ✅ All security checks pass
- ✅ Recovery procedures tested
- ✅ Documentation complete
- ✅ Phase 2 (Orchestrator) ready to start

---

## Phase 2: Bootstrap Orchestrator

**Objective**: Implement MetaGPT-based orchestrator that reads AGENTS.md and coordinates task delegation.

**Duration**: 2 weeks  
**Dependencies**: Phase 1 complete  
**Acceptance Criteria**:
- ✅ Orchestrator reads AGENTS.md and builds Role graph
- ✅ Orchestrator delegates tasks to MCP-enabled tools
- ✅ Orchestrator handles inter-agent conflicts
- ✅ Orchestrator recovers from tool failures
- ✅ ≥90% test coverage

### Phase 2.1: Orchestrator Core

**Objective**: Integrate MetaGPT framework; build role instantiation from AGENTS.md.

### Phase 2.2: Task Delegation

**Objective**: Implement task routing and state management across roles.

### Phase 2.3: Error Recovery

**Objective**: Handle tool failures; implement retry logic.

### Phase 2 Final Integration

**Final Tag**: `v2.0.0-Phase-2-Complete`

---

## Phase 3: Specialized Agents

**Objective**: Implement first 3 specialized agents (Security, Test, Document) fulfilling SKILL.md contracts.

**Duration**: 2 weeks  
**Dependencies**: Phase 2 complete  
**Acceptance Criteria**:
- ✅ Security agent (SAST, dependency scanning)
- ✅ Test agent (generates unit tests; measures coverage)
- ✅ Document agent (generates docstrings; enforces coverage gates)
- ✅ ≥90% test coverage per agent
- ✅ Each agent passes compliance check

### Phase 3.1: Security Agent

**Checkpoint**: `CKPT-3.1-Security-Agent`

### Phase 3.2: Test Agent

**Checkpoint**: `CKPT-3.2-Test-Agent`

### Phase 3.3: Document Agent

**Checkpoint**: `CKPT-3.3-Document-Agent`

### Phase 3 Final Integration

**Final Tag**: `v3.0.0-Phase-3-Complete`

#### Implementation Guidance: Do NOT Reinvent

| Agent | Existing Tool/Pattern | Don't Build | Reuse |
|-------|----------------------|-------------|-------|
| **Security** | bandit (Python SAST rules), safety (CVE db), detect-secrets (entropy + patterns), Ship Safe (multi-specialist pattern) | Custom SAST engine, custom secret detector | Use existing tools + wrap in MetaGPT Role; pattern after Ship Safe supervisors |
| **Test** | pytest, coverage.py, hypothesis (property testing), OpenAI Cookbook patterns | Test oracle, custom coverage analyzer | Use coverage.py for gaps; Claude to generate; pytest to validate |
| **Document** | interrogate (docstring coverage), existing docstring schemas (NumPy/Google), Claude for generation | Docstring parser, custom coverage tool | Use interrogate for enforcement; Claude for generation; AST for parsing |

**Security Agent Implementation Notes**:
- Use `bandit` (CLI + library) for built-in SAST rules
- Use `safety` (CLI) for CVE scanning via `mcp-process`
- Use `detect-secrets` (CLI) for secrets detection
- Wrap each via MCP Process server
- Aggregate results in Security Role
- Pattern after Ship Safe: supervisor coords specialists

**Test Agent Implementation Notes**:
- Use `coverage.py` library to identify uncovered lines
- Use Claude to generate tests for gap lines
- Use pytest to validate generated tests
- Iterate until coverage ≥90%
- No custom test oracle or coverage analyzer

**Document Agent Implementation Notes**:
- Use `interrogate` CLI to find undocumented functions
- Use Claude to generate docstrings (NumPy/Google style)
- Parse AST to find undocumented module/class/function
- Use interrogate to re-measure coverage
- Iterate until coverage ≥90%

---

### Phase 3 Final Integration & Verification

**Final Tag**: `v3.0.0-Phase-3-Complete`

---

## Cross-Phase Integration Points

| Integration Point | Phase | Details |
|-------------------|-------|---------|

**Reuse Strategy**: Study existing production agents (Ship Safe, existing test patterns, existing docstring models); adapt rather than reinvent. Use existing tools (bandit, safety, pytest, interrogate) wrapped via MCP or invoked directly.
| **Orchestrator → Specialized Agents** | 3 | Orchestrator instantiates agents as MetaGPT Roles |

---

## Recovery & Rollback Procedures

### Scenario 1: Agent Session Failure (Mid-Phase)

**Symptoms**: Process terminated, state partially written

**Recovery**:

```bash
# 1. Check last checkpoint
LAST_CKPT=$(git describe --tags --match "*-CKPT-*" --abbrev=0)
echo "Last checkpoint: $LAST_CKPT"

# 2. Load phase state
python -c "
from agents_harness.state import StateManager
sm = StateManager(...)
state = sm.load_phase_state(phase=0)
print(state)
"

# 3. Identify next task
# (Refer to Phase 0–3 deliverables; find next uncompleted checkpoint)

# 4. Resume from next checkpoint
# (Follow "Implementation Details" for that checkpoint)
```

### Scenario 2: Test Failure (Validation Fails)

**Symptoms**: ValidationMiddleware rejects code output

**Recovery**:

```bash
# 1. Check validation report
cat /workspaces/agents/.agent-state/evidence/phase-X-validation-report.html

# 2. Review failing test
pytest tests/test_validation.py -v --tb=short

# 3. Fix code or test
# (Edit source; re-run validation)

# 4. Commit with "fixes" message
git commit -am "fixes: Address validation failure in <subsystem>"

# 5. Re-run from checkpoint
```

### Scenario 3: Git Worktree Corruption

**Symptoms**: Worktree cannot be cleaned or is in detached state

**Recovery**:

```bash
# 1. Manually list worktrees
git worktree list

# 2. Force remove corrupted worktree
git worktree remove --force /workspaces/agents/.agent-state/tasks/<task_id>

# 3. Verify main branch is clean
git status

# 4. Recreate worktree
python -c "
from agents_harness.worktree import WorktreeManager
wm = WorktreeManager(...)
wm.create_worktree(task=...)
"
```

### Scenario 4: Audit Log Corruption (Hash Chain Broken)

**Symptoms**: `AuditLogger.verify_chain()` returns False

**Recovery**:

```bash
# 1. Identify corrupted entry
python -c "
from agents_harness.audit import AuditLogger
al = AuditLogger(...)
al.verify_chain()  # This will log error at corruption point
"

# 2. Backup corrupted log
cp /workspaces/agents/.agent-state/logs/execution.jsonl \
   /workspaces/agents/.agent-state/logs/execution.jsonl.corrupted

# 3. Rewind to last verified entry
# (Manual JSONL editing; remove corrupted entries)

# 4. Re-verify chain
python -c "from agents_harness.audit import AuditLogger; al.verify_chain()"

# 5. Re-run corrupted checkpoint
```

### Scenario 5: Phase Rollback (Need to Undo Changes)

**Symptoms**: Phase output does not meet acceptance criteria

**Rollback**:

```bash
# 1. Identify rollback target
# (Check available tags: git tag -l "*CKPT*")

# 2. Reset to prior checkpoint
git reset --hard v0.1.0-CKPT-0.1-StateManager-Core

# 3. Clean worktrees
python -c "
from agents_harness.worktree import WorktreeManager
wm = WorktreeManager(...)
wm.auto_cleanup_expired(ttl_hours=0)  # Force cleanup all
"

# 4. Clear phase state
rm /workspaces/agents/.agent-state/phase-0-checkpoints.jsonl

# 5. Start phase over from checkpoint
```

---

## Audit & Compliance Checklist

Every phase completion must verify all checklist items:

### Security Checklist

- [ ] **Authentication & Authorization**
  - [ ] All services implement JWT or OAuth2
  - [ ] RBAC enforced on write endpoints
  - [ ] No default/public access
  
- [ ] **Input Validation**
  - [ ] All endpoints use Pydantic strict mode
  - [ ] Password strength validation (if applicable)
  - [ ] Regex patterns enforced on names/IDs
  - [ ] No mass-assignment vulnerabilities
  
- [ ] **Data Protection**
  - [ ] PII masked in logs and error messages
  - [ ] No credentials in code or logs
  - [ ] Audit logs are append-only and hash-chained
  
- [ ] **Security Headers**
  - [ ] X-Content-Type-Options: nosniff
  - [ ] X-Frame-Options: DENY
  - [ ] HSTS header present (if HTTPS)
  - [ ] Cache-Control: no-store (for sensitive endpoints)
  
- [ ] **Rate Limiting**
  - [ ] All public endpoints rate-limited
  - [ ] Auth endpoints rate-limited
  - [ ] Slowapi middleware configured
  
- [ ] **Static Analysis**
  - [ ] `bandit -r src/` passes (0 HIGH severity issues)
  - [ ] `safety check` passes
  - [ ] No hardcoded secrets (detect-secrets)

### Code Quality Checklist

- [ ] **Testing**
  - [ ] `pytest --cov=src/ --cov-fail-under=90` passes
  - [ ] All critical paths have tests
  - [ ] Edge cases tested (errors, boundary conditions)
  
- [ ] **Type Safety**
  - [ ] `mypy --strict src/` passes (0 errors)
  - [ ] All function signatures typed
  - [ ] Generics used where appropriate
  
- [ ] **Documentation**
  - [ ] `interrogate -vv src/ --fail-under 90` passes
  - [ ] Module-level docstrings present
  - [ ] Function docstrings include args, returns, raises
  - [ ] Test docstrings document pass criteria
  
- [ ] **Code Style**
  - [ ] `ruff check src/` passes
  - [ ] `ruff format src/` applied
  - [ ] No import cycles
  
- [ ] **Architecture**
  - [ ] Layer boundaries enforced (BoundaryChecker)
  - [ ] No circular dependencies
  - [ ] Config → Models → Services → API order maintained

### Operational Checklist

- [ ] **Logging & Monitoring**
  - [ ] Structured JSON logging configured
  - [ ] All errors logged with context
  - [ ] Audit trail includes correlation IDs
  - [ ] OTel hooks present (if applicable)
  
- [ ] **Deployment & DevOps**
  - [ ] `pyproject.toml` with all dependencies pinned
  - [ ] `uv.lock` checked in
  - [ ] GitHub Actions CI/CD configured
  - [ ] Docker build (if applicable) tested
  
- [ ] **Git Workflow**
  - [ ] Branch naming convention followed
  - [ ] Commit messages include context
  - [ ] Tags created for checkpoints
  - [ ] PR descriptions link to issues/milestones

### Compliance Checklist

- [ ] **Audit Trail**
  - [ ] `AuditLogger.verify_chain()` passes
  - [ ] No missing entries in execution.jsonl
  - [ ] All decisions traceable to evidence files
  
- [ ] **Deterministic Rails**
  - [ ] ValidationMiddleware blocks all non-compliant outputs
  - [ ] BoundaryChecker enforces layer model
  - [ ] No agent output bypasses validation
  
- [ ] **Recovery Procedures**
  - [ ] Rollback procedures tested
  - [ ] Session recovery tested from each checkpoint
  - [ ] Documentation updated
  
- [ ] **Handoff Ready**
  - [ ] Code review completed
  - [ ] All tests passing
  - [ ] Documentation complete
  - [ ] Next phase can start without delays

---

## Success Criteria & Milestone Tracking

### Milestone Definitions

| Milestone | Phase | Criteria | Target Date |
|-----------|-------|----------|-------------|
| **M0: Kernel Ready** | 0 | All 5 subsystems complete, tested, integrated | Week 4 (2026-05-24) |
| **M1: Protocols Ready** | 1 | MCP servers wrap all subsystems | Week 5 (2026-05-31) |
| **M2: Orchestrator Live** | 2 | MetaGPT orchestrator reads AGENTS.md and delegates tasks | Week 7 (2026-06-14) |
| **M3: First Agents** | 3 | Security, Test, Document agents functional | Week 9 (2026-06-28) |
| **M4: Production Ready** | — | Full compliance audit passed; rollback tested | Week 12 (2026-07-19) |

### Metrics to Track

| Metric | Target | Measurement |
|--------|--------|-------------|
| **Test Coverage** | ≥90% | `pytest --cov` per phase |
| **Type Safety** | 0 mypy errors | `mypy --strict src/` |
| **Security Issues** | 0 HIGH/CRITICAL | `bandit`, `safety` |
| **Linting** | 0 violations | `ruff check src/` |
| **Docstring Coverage** | ≥90% | `interrogate` |
| **Audit Chain Integrity** | 100% | `AuditLogger.verify_chain()` |
| **Checkpoint Recovery** | 100% | Test resume from each tag |
| **Phase Duration** | ±10% of estimate | Track actual vs. planned |

### Definition of Done (Per Phase)

A phase is **Done** when:

1. ✅ All deliverables completed and merged to `main`
2. ✅ All acceptance criteria verified
3. ✅ All tests passing (≥90% coverage)
4. ✅ All security checks passing
5. ✅ All audit checklist items verified
6. ✅ Rollback procedure tested
7. ✅ Checkpoint tagged in Git
8. ✅ State saved to `.agent-state/`
9. ✅ Next phase can start without blocking
10. ✅ Documentation updated

---

## How to Use This Plan

### For Agents (AI or Human)

1. **Understand Your Phase**
   - Read the phase section (0–3)
   - Understand objectives and acceptance criteria
   - Identify checkpoints

2. **Check Current State**
   ```bash
   git describe --tags --match "*-CKPT-*" --abbrev=0
   cat /workspaces/agents/.agent-state/current_checkpoint.txt
   ```

3. **Load Context**
   ```bash
   python -c "
   from agents_harness.state import StateManager
   sm = StateManager(...)
   phase_state = sm.load_phase_state(phase=0)
   print(phase_state)
   "
   ```

4. **Execute Next Checkpoint**
   - Follow "Implementation Details" for your checkpoint
   - Implement deliverables
   - Run tests
   - Commit and tag
   - Log to audit trail

5. **Recover from Failure**
   - Check "Recovery & Rollback Procedures"
   - Reset to last known good checkpoint
   - Resume from next checkpoint
   - Re-run tests

### For Compliance & Regulatory Oversight

This plan demonstrates:

1. **Fidelity to Requirements**
   - Clear objectives, deliverables, acceptance criteria per phase
   - Verifiable checkpoints and tags
   - Traceability back to assessment document

2. **Audit Trail & Compliance**
   - Every decision logged to immutable, hash-chained audit log
   - Detailed recovery procedures for session/machine failures
   - Security and code quality checks built-in from inception

3. **Deterministic Execution**
   - No ambiguity; agents can resume from any checkpoint
   - Clear success criteria; no hand-waving
   - Compliance checklist verified at each phase

4. **Risk Mitigation**
   - Rollback procedures documented and tested
   - Phase gates prevent cascading failures
   - State persistence ensures no work is lost

---

## Appendix: Quick Reference

### Git Commands

```bash
# Check current checkpoint
git describe --tags --match "*-CKPT-*" --abbrev=0

# Create checkpoint tag
git tag -a v0.1.0-CKPT-0.1-StateManager-Core \
  -m "Phase: 0; Checkpoint: StateManager; Status: Complete"

# List all checkpoints
git tag -l "*-CKPT-*"

# Reset to checkpoint
git reset --hard v0.1.0-CKPT-0.1-StateManager-Core
```

### Audit Commands

```bash
# Verify hash chain
python -c "from agents_harness.audit import AuditLogger; al = AuditLogger(...); print(al.verify_chain())"

# View audit log
tail -f /workspaces/agents/.agent-state/logs/execution.jsonl

# Query audit entries
python -c "from agents_harness.audit import AuditLogger; al = AuditLogger(...); print(al.get_entries('StateManager'))"
```

### Testing Commands

```bash
# Run tests with coverage
pytest tests/ --cov=src/agents_harness --cov-fail-under=90

# Run security checks
bandit -r src/
safety check

# Run type checks
mypy --strict src/

# Run docstring checks
interrogate -vv src/ --fail-under 90

# Full compliance check
pytest tests/ && mypy --strict src/ && bandit -r src/ && safety check && interrogate -vv src/
```

---

## Document Metadata

- **Plan Version**: 1.0
- **Created**: 2026-04-25
- **Last Updated**: 2026-04-25
- **Status**: Ready for Execution
- **Author**: Copilot (Analysis & Plan Generation)
- **Reviewed By**: (Pending compliance review)
- **Approved By**: (Pending approval)
- **Next Review Date**: Post-Phase-1
- **Audit Hash**: (To be computed when plan is frozen)

---

**End of Plan Document**
