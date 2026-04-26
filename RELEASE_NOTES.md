# Release Notes

<<<<<<< HEAD

## 0.1.0 - 2026-04-25

This release introduces robust, auditable context integrity and memory management controls to the agentic AI ecosystem assessment and plan.

### Highlights
- Added a dedicated section on context integrity & memory management to the assessment and plan files.
- Enforced persistent structured memory, context window management, goal/plan traceability, automated consistency checks, audit logging, and human-in-the-loop verification for all phases.

### Validation
- Verified that both assessment and plan files now require and document context/memory controls and acceptance criteria.
- Ensured release metadata synchronization across VERSION, CHANGELOG.md, and RELEASE_NOTES.md.

### Affected Areas
- Assessment and plan files in `tests/`
- Root governance and release documentation

## 0.0.9 - 2026-04-25

This release hardens Python repository generation quality by making documentation enforcement a required, machine-checked gate.

### Highlights
- Updated `AGENTS.md` with root policy requiring machine-enforced documentation checks for new Python repositories.
- Updated canonical Python generation instructions to require:
  - `interrogate` in dev dependencies
  - `[tool.interrogate]` coverage threshold configuration
  - CI docstring coverage step before tests
- Updated enterprise checklist and compatibility prompt guidance to reinforce the same requirement.

### Validation
- Verified policy updates were applied in the canonical Python instruction path and checklist path.
- Ensured release metadata synchronization across `VERSION`, `CHANGELOG.md`, and `RELEASE_NOTES.md`.

### Affected Areas
- root governance policy in `AGENTS.md`
- Python generation guidance in `docs/config/python/instructions/`
- Python compatibility prompt in `docs/config/python/prompts/`

## 0.0.8 - 2026-04-24

This release simplifies the root agent policy and moves Python-specific guidance to the Python configuration surfaces where it belongs.

### Highlights
- Reworked `AGENTS.md` into a concise, language-neutral root policy.
- Moved Python-specific architecture and documentation guidance into `docs/config/python/instructions/python-code-generation-instructions.md`.
- Updated the Python compatibility prompt to explicitly direct Python-only guidance away from the root policy.
- Added `CLAUDE.md` as a compatibility import that references `AGENTS.md`.

### Validation
- Reviewed the resulting diffs for `AGENTS.md`, the Python instruction file, the Python prompt file, and `CLAUDE.md`.
- Verified that the `.github` runtime mirror files already matched the updated Python guidance.

### Affected Areas
- root repository agent policy in `AGENTS.md`
- Python instruction and prompt guidance under `docs/config/python/`
- compatibility entry point in `CLAUDE.md`

## 0.0.7 - 2026-04-24

This release hardens repository governance by making version fidelity and major-change workflow rules explicit in `AGENTS.md`.

### Highlights
- Added a version and documentation fidelity policy for all framework, SDK, API, and CLI usage.
- Added required verification order for target versions using lockfiles, manifests, and internal API specs.
- Added stronger major-change workflow rules for branching, PRs, tagging, traceability, and main branch protection.
- Added a minimum execution sequence for major repository changes.

### Validation
- Reviewed the resulting `AGENTS.md` diff directly before release.
- Released as a separate follow-up branch and PR to keep governance changes isolated from the 0.0.6 scaffold release.

### Affected Areas
- root repository agent governance in `AGENTS.md`
- release metadata for version 0.0.7

## 0.0.6 - 2026-04-24

This release upgrades the repository from a guidance-first bootstrap to a reusable enterprise Python service generator.

### Highlights
- Added `scripts/create_python_fastapi_service.sh` for production-grade FastAPI service scaffolding.
- Generated services now include:
  - JWT auth using bcrypt with SHA-256 pre-hash
  - RBAC dependency guards
  - TrustedHost, CORS, and security headers
  - `slowapi` rate limiting
  - structured JSON logging
  - Prometheus metrics and OpenTelemetry hooks
  - lifespan-based FastAPI startup
  - SQLite example domain service and validation tests
  - GitHub Actions CI workflow
- Preserved `scripts/create_python_repo.sh` as the lightweight repo bootstrap path.

### Validation
- Generated a fresh service scaffold and ran `uv run pytest -q` successfully.
- Verified the generator script syntax and repo metadata alignment before release.

### Affected Areas
- root repo documentation and release metadata
- Python onboarding workflow
- production service generation path under `scripts/`
<<<<<<< HEAD
=======
## v0.1.1
### Highlights
- Introduced `LoggingMiddleware` for structured logging.
- Added comprehensive unit tests for logging functionality.
- Updated README.md with usage examples for LoggingMiddleware.
>>>>>>> 5333cd9 (Initialize repository with LoggingMiddleware, tests, documentation, changelog, and release notes)
=======

### Release Notes

#### Changes
- The `config` directory has been relocated to `docs/config` to consolidate all documentation-related files.
>>>>>>> 320e37e (Relocate config directory to docs/config and update documentation)
