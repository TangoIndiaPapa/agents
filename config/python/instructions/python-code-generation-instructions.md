# Python Code Generation Standards

Canonical Python source mirrored to `.github/instructions/python-code-generation.instructions.md` for repo-local runtime discovery.

## Role And Operating Intent

- Operate as a Python architect focused on resource-efficient, production-ready systems.
- Favor established frameworks and libraries over bespoke boilerplate.

## Reference Architectures

- Use `pydantic-ai` for agentic or LLM-centric Python workflows when that pattern applies.
- Use `tiangolo/full-stack-fastapi-template` as the default reference for FastAPI API and database-oriented directory structure decisions when a stronger repo-local pattern does not already exist.
- Use `pydantic-settings` for configuration; do not write custom `.env` parsers.

## Core Directives

### 1. Anti-Bespoke Logic
- Scaffold first and avoid custom boilerplate when a reputable template or library already solves the problem.
- Prefer established Python patterns for API, configuration, and validation.
- Default tooling: `uv` for dependency management and `ruff` for linting and formatting.

### 2. Token And Cost Economy
- Keep edits differential and concise.
- Prefer reputable libraries over custom implementations when that improves quality and reduces maintenance.
- Use modern Python 3.10+ syntax when it improves clarity without harming compatibility.
- If a feature is better solved with a reputable PyPI package, prefer the package over bespoke code.
- When a template materially affects the solution, state the chosen template or library path briefly.

## Workflow Protocol

1. Identify the repository's existing version and framework constraints before implementing.
2. State the chosen library or template path briefly when it materially affects the solution.
3. Prefer established scaffolding commands when starting new Python work.
4. Output only the necessary code and guidance.

## Python Guidelines

- Follow PEP 8 and PEP 20.
- Generate corresponding `pytest` coverage for new or changed Python behavior when warranted.
- Run actual logic in tests whenever practical.
- Run Python commands from the correct repository directory.
- Set `PYTHONPATH` to include the current directory and `src` when applicable.
- Use `uv venv .venv` for virtual environments.
- Activate the environment with `source .venv/bin/activate` when needed.
- Do not manipulate `sys.path` directly.
- Use proper imports.
- Place tests under the root `tests/` directory.
- Ensure `pytest` is installed in the active environment.
- Run tests with `uv run pytest`.

## Architecture Principles

- Separate concerns cleanly across config, models, repositories or data access, services, API, and middleware when those layers exist.
- Prefer dependency injection over hidden global state.
- Keep operations idempotent where retry behavior is plausible.
- Favor 12-factor configuration through `pydantic-settings`.

## Documentation Standards

- Add docstrings on public functions and classes when intent is not obvious.
- Prefer comments that explain why a decision exists, not what the code mechanically does.
- Keep README setup and architecture guidance current when scaffold or runtime expectations change.
- Every new repository README must include:
  - An ASCII architecture diagram showing components, data flow direction, transport, and protocol.
  - A repository structure tree showing all source directories and key files with inline annotations.

### Inline Documentation Rules

- Module docstrings must explain: what the module does, why key design decisions were made, and any
  non-obvious constraints (e.g. STDIO-only logging, task-context lifecycle rules).
- Every public function and method must have a docstring covering: purpose, args, and return value.
  One-liner docstrings are acceptable only when the function name and signature are fully self-describing.
- Inline comments should explain *why* a choice was made, not restate what the code does.
  Examples of good inline comments: why a guard condition exists, why a specific algorithm was chosen,
  why a seemingly redundant check is intentional.
- Test functions must include a docstring stating the pass criteria so failure diagnosis does not
  require reading the assertion details.

### Documentation Enforcement (Mandatory)

- Documentation standards must be machine-enforced for all newly generated Python repositories.
- Add `interrogate>=1.7.0,<2.0.0` to dev dependencies.
- Add `[tool.interrogate]` in `pyproject.toml` with:
  - `fail-under = 95` minimum docstring coverage
  - private members ignored (`ignore-private = true`)
  - init modules/methods included (`ignore-init-module = false`, `ignore-init-method = false`)
- Add a CI workflow step that runs `uv run interrogate src/<package_name>` before tests.
- Do not mark work complete until local `interrogate` output passes the configured threshold
  and the CI workflow contains the docstring gate.

## Error Handling

- Use try/catch blocks for async operations when failure handling matters.
- Always log errors with useful context.

## FastAPI Integration Patterns

- When using Pydantic `EmailStr`, add `email-validator` dependency explicitly.
- Configure `TrustedHostMiddleware` with environment-aware allowed hosts and ensure test hosts are supported.
- Use one shared `slowapi` limiter instance, register it on `app.state.limiter`, and wire `RateLimitExceeded` handlers.
- For rate-limit tests, assert HTTP `429` responses and avoid server exception bubbling in test client setup when needed.
- Keep tracing instrumentation enabled, but make console span exporting opt-in for tests and local debug sessions.
- Prefer FastAPI lifespan handlers for startup/shutdown initialization instead of deprecated event decorators.

## Bootstrap Quality Expectations

- New Python repo scaffolds should include a minimal `.gitignore` and a baseline CI workflow for running pytest.
- Bootstrap-created READMEs should include runnable setup commands in fenced code blocks.

## Quality Gate

- Do not re-implement standard library or framework capabilities unnecessarily.
- Keep code type-safe and validated.
- Prefer shorter, clearer solutions when they preserve behavior.
- If Pydantic is already the validation layer, use it consistently instead of introducing unvalidated dictionaries or parallel validation logic.
- Do not mark work complete when major public functions lack docstrings or when non-trivial modules lack module-level intent/constraint documentation.

## END
