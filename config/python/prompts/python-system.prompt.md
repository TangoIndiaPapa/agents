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

Critical implementation guardrails:
1. If `EmailStr` is used, include `email-validator` dependency.
2. If `TrustedHostMiddleware` is used, include test host handling strategy.
3. Use shared `slowapi` limiter wiring with app-level registration.
4. Keep tracing instrumentation, but gate noisy console exporters in tests.
5. Prefer FastAPI lifespan handlers over deprecated startup/shutdown event decorators.
6. New repo scaffolds should include a minimal CI workflow and clean setup documentation.

## END