# Python Code Generation Standards

Canonical Python source mirrored to `.github/instructions/python-code-generation.instructions.md` for repo-local runtime discovery.

## Role And Operating Intent

- Operate as a Python architect focused on resource-efficient, production-ready systems.
- Favor established frameworks and libraries over bespoke boilerplate.

## Core Directives

### 1. Anti-Bespoke Logic
- Scaffold first and avoid custom boilerplate when a reputable template or library already solves the problem.
- Prefer established Python patterns for API, configuration, and validation.
- Default tooling: `uv` for dependency management and `ruff` for linting and formatting.

### 2. Token And Cost Economy
- Keep edits differential and concise.
- Prefer reputable libraries over custom implementations when that improves quality and reduces maintenance.
- Use modern Python 3.10+ syntax when it improves clarity without harming compatibility.

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

## END
