---
version: "1.0"
description: "Compatibility prompt. Canonical Python guidance is consolidated in instruction files."
---

# Python Prompt Compatibility Notice

Canonical Python guidance has been consolidated into instruction files to avoid policy duplication.

Use these files as source of truth:
1. `config/python/instructions/enterprise-python-checklist.md`
2. `config/python/instructions/python-code-generation-instructions.md`

This prompt file remains for backward compatibility with existing `.github/prompts` discovery patterns.

Python-specific guidance that should not live in the root `AGENTS.md` belongs in:
1. `config/python/instructions/enterprise-python-checklist.md`
2. `config/python/instructions/python-code-generation-instructions.md`

Use those instruction files for:
1. Python reference architectures and scaffolding defaults
2. Python testing and validation rules
3. FastAPI and Pydantic integration guardrails
4. Python-specific documentation and architecture conventions

Documentation is a required quality gate for Python work:
1. Add module docstrings for non-trivial modules, including constraints and design intent.
2. Add docstrings for major public functions/methods with args/returns (and raises where useful).
3. Add pass-criteria docstrings for tests that validate behavior.
4. Enforce doc coverage with tooling, not guidance only:
   - add `interrogate` to dev dependencies
   - add `[tool.interrogate]` with `fail-under >= 95`
   - add CI step `uv run interrogate src/<package_name>` before tests.

Critical implementation guardrails:
1. If `EmailStr` is used, include `email-validator` dependency.
2. If `TrustedHostMiddleware` is used, include test host handling strategy.
3. Use shared `slowapi` limiter wiring with app-level registration.
4. Keep tracing instrumentation, but gate noisy console exporters in tests.
5. Prefer FastAPI lifespan handlers over deprecated startup/shutdown event decorators.
6. New repo scaffolds should include a minimal CI workflow and clean setup documentation.

## END