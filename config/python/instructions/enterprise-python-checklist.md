# Enterprise Python — Mandatory Checklist

Canonical Python source mirrored to `.github/instructions/enterprise-python-checklist.instructions.md` for repo-local runtime discovery.

**Version:** 1.0
**Purpose:** Ensure every generated Python service meets enterprise production quality from the first generation. Do not scaffold first and secure later.

## Security-Native Baseline

- Use Pydantic v2 validation on all data entry points.
- Never hardcode secrets.
- Use `pydantic-settings` for configuration.
- When generating Dockerfiles, default to non-root users and multi-stage builds.

## Pre-Generation Gate

When asked to generate a new Python service, API, or microservice, include all of the following in the initial code generation.

### 1. Authentication
- JWT Bearer token auth using PyJWT and `bcrypt` directly, not `passlib`
- Password hashing with `bcrypt` plus SHA-256 pre-hash for long passwords
- Password strength validation with minimum length, upper, lower, and digit rules
- OAuth2PasswordBearer flow with `/auth/login` and `/auth/register`
- Token expiry configuration via environment variable

### 2. Authorization
- RBAC on every write endpoint
- Principle of least privilege with separate admin/member/viewer roles
- Dependency injection for role checking via a `require_roles()` factory or equivalent
- Self-edit rule: users can update their own profile, admins can update anyone

### 3. Rate Limiting
- `slowapi` or equivalent on all public-facing endpoints
- Stricter limits on auth endpoints to reduce brute-force risk
- Configurable rate limits via environment variables
- Proper `429` handling

### 4. Input Validation And OWASP Protections
- Pydantic v2 strict validation on inbound schemas
- Separate Create, Update, and Response schemas
- Name field regex constraints to reject HTML, SQL, and numeric-only content where appropriate
- Max-length enforcement on string fields
- Email enumeration prevention with masked PII in error messages

### 5. Security Middleware
- Explicit CORS origins only, never wildcard in production
- Trusted Host middleware for host-header protection
- Security headers including `X-Content-Type-Options`, `X-Frame-Options`, `Cache-Control: no-store`, and HSTS
- Disable docs/redoc in production mode

### 6. Logging And Observability
- Structured JSON logging
- Security event logging for failed logins, access denials, and duplicate email attempts
- Request logging with method, path, status, and duration
- No PII in logs

### 7. Testing
- Unit tests for Pydantic models and edge cases
- Service-layer tests with a real in-memory database where practical
- API integration tests with auth tokens
- Auth flow tests for register, login, expired token, invalid token, and RBAC
- Security tests for injection, mass assignment, enumeration, and headers
- Rate-limit tests
- Coverage target of at least 90%
- Baseline CI workflow that runs tests on pull requests and main branch updates

### 8. Configuration
- 12-factor config via `pydantic-settings`
- No hardcoded secrets; use environment variables with safe placeholder defaults
- Security knobs configurable through settings

### 9. Error Handling And Resilience
- Meaningful try/catch blocks where failure isolation matters
- Helpful logs for failure diagnosis
- Back-pressure handling and backoff with jitter where applicable

### 10. Documentation
- Readable code favored over cleverness
- Comments and docstrings where intent is not obvious
- README kept current with architecture and expectations

## Interaction Model

- Favor deterministic, reproducible outputs.
- Do not assume missing requirements.
- Protect privacy and redact sensitive values.

## Known Pitfalls

- `passlib` with `bcrypt >= 4.1` is broken; use `bcrypt` directly with SHA-256 pre-hash
- `slowapi` module-level settings can bypass test overrides; use factory patterns
- `lru_cache` on settings can block test override propagation; pass settings through args or app state
- Pin `pytest-asyncio` to `>=0.24,<1.0` with `asyncio_mode = "auto"`

## Framework Integration Guardrails

- If using Pydantic `EmailStr`, include `email-validator` in project dependencies.
- If using `TrustedHostMiddleware`, include a test strategy for host validation (for example `testserver` in test env allowed hosts).
- Use a JWT secret with at least 32 bytes for HS256-class algorithms.
- For rate limiting with `slowapi`, use a shared limiter instance and attach it to `app.state.limiter` with proper exception handler registration.
- Keep tracing enabled, but gate noisy exporters (for example console exporters) behind an environment variable in test runs.
- Prefer FastAPI lifespan handlers over deprecated `@app.on_event("startup")` / `@app.on_event("shutdown")` patterns.

## Python Execution Standards

- Follow PEP 8 and PEP 20
- Generate or update pytest coverage for new Python behavior
- Run real tests, not simulated tests
- Use `uv venv .venv` and activate the environment before Python work when needed
- Set `PYTHONPATH` correctly instead of manipulating `sys.path`
- Place tests under a root `tests/` directory
- Run tests with `uv run pytest`

## Quality Assertion

Before declaring a Python codebase done, verify:

1. Unauthenticated users cannot access non-public endpoints.
2. Non-privileged users cannot perform privileged writes.
3. Authentication endpoints are rate limited.
4. Error messages do not leak PII.
5. Protected endpoint tests use auth tokens.

## END
