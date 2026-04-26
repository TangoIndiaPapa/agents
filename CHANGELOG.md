# Changelog

<<<<<<< HEAD
All notable changes to this repository are documented in this file.

## [0.1.0] - 2026-04-25

### Added
- Context Integrity & Memory Management: Added robust, auditable controls to prevent memory rot, context dilution, hallucination, and lost goals in long-running agentic workflows.
- Updated assessment and plan files to enforce persistent structured memory, context window management, goal/plan traceability, automated consistency checks, audit logging, and human-in-the-loop verification for all phases.

### Notes
- This release ensures all future work is protected against context and memory issues, with clear acceptance criteria and recovery protocols.

## [0.0.9] - 2026-04-25

### Changed
- Updated `AGENTS.md` to require machine-enforced documentation checks for new Python repositories.
- Updated `config/python/instructions/python-code-generation-instructions.md` to mandate:
  - `interrogate` dev dependency
  - `[tool.interrogate]` configuration with minimum coverage threshold
  - CI docstring coverage step before tests
- Updated `config/python/instructions/enterprise-python-checklist.md` to include required docstring coverage enforcement.
- Updated `config/python/prompts/python-system.prompt.md` to reinforce documentation enforcement in compatibility guidance.

### Notes
- This release converts documentation quality from advisory guidance to enforceable policy for future generated Python repositories.

## [0.0.8] - 2026-04-24

### Changed
- Reworked `AGENTS.md` from a Python-heavy system prompt into a concise, language-neutral root policy.
- Moved Python-specific reference architecture, architecture principles, and documentation standards into `config/python/instructions/python-code-generation-instructions.md`.
- Updated `config/python/prompts/python-system.prompt.md` to make the root-vs-language guidance split explicit.

### Added
- Added `CLAUDE.md` as a compatibility import that points at `AGENTS.md`.

### Notes
- The repository root policy is now shorter and easier for agents to classify quickly.
- Python-specific rules remain in the Python config surfaces instead of being duplicated at the root.

## [0.0.7] - 2026-04-24

### Changed
- Updated `AGENTS.md` with a version and documentation fidelity policy.
- Added explicit requirements for version-source verification before implementation.
- Strengthened major-change governance with clearer main-branch protection, release traceability, and minimum execution steps.

### Policy Additions
- target-version verification from lockfiles, manifests, or internal API specs
- PR and commit notes must include version evidence for major dependency or API changes
- main branch stability and no direct major-change commits to main
- minimum execution sequence for branch, merge, tag, and push operations

## [0.0.6] - 2026-04-24

### Added
- Added `scripts/create_python_fastapi_service.sh` to generate a production-grade FastAPI service scaffold.

### Changed
- Updated onboarding and root documentation to make the enterprise FastAPI scaffold the preferred path for new production Python services.

### Scaffold Includes
- JWT auth with bcrypt + SHA-256 pre-hash
- RBAC dependency guards
- TrustedHost, CORS, and security headers
- `slowapi` rate limiting
- structured JSON logging
- Prometheus metrics and OpenTelemetry hooks
- lifespan-based FastAPI startup
- SQLite-backed example domain service and validation tests
- GitHub Actions CI workflow

## [0.0.5] - 2026-04-24

### Changed
- Updated Python guidance to address `agent-python-test-4` evaluation findings.
- Added explicit guidance to prefer FastAPI lifespan handlers over deprecated startup/shutdown event decorators.
- Added bootstrap quality expectations for new Python repos:
  - minimal `.gitignore`
  - baseline GitHub Actions CI workflow
  - fenced setup commands in generated README files

### Updated Files
- `config/python/instructions/enterprise-python-checklist.md`
- `config/python/instructions/python-code-generation-instructions.md`
- `config/python/prompts/python-system.prompt.md`
- `.github/instructions/enterprise-python-checklist.instructions.md`
- `.github/instructions/python-code-generation.instructions.md`
- `.github/prompts/python-system.prompt.md`
- `scripts/create_python_repo.sh`

## [0.0.4] - 2026-04-24

### Changed
- Hardened Python guidance to prevent recurring scaffold issues discovered during `agent-python-test-2` validation.
- Updated canonical instruction files with explicit implementation guardrails for:
  - Pydantic `EmailStr` dependency (`email-validator`)
  - `TrustedHostMiddleware` test-host handling
  - `slowapi` shared limiter and app-state wiring
  - test-safe tracing exporter configuration
- Updated prompt compatibility guidance with concrete guardrail reminders.

### Updated Files
- `config/python/instructions/enterprise-python-checklist.md`
- `config/python/instructions/python-code-generation-instructions.md`
- `config/python/prompts/python-system.prompt.md`
- `.github/instructions/enterprise-python-checklist.instructions.md`
- `.github/instructions/python-code-generation.instructions.md`
- `.github/prompts/python-system.prompt.md`

## [0.0.3] - 2026-04-24

### Added
- Added generic guidance sync script with copy-first behavior:
  - `scripts/sync_guidance_files.sh`
- Added Python repository creation script that scaffolds a new repo and copies guidance files at creation time:
  - `scripts/create_python_repo.sh`

### Changed
- Updated `scripts/sync_guidance_symlinks.sh` to act as a compatibility wrapper using symlink mode.
- Updated onboarding documentation to make copy-at-creation the default workflow:
  - `README.md`
  - `config/python/README.md`

### Notes
- Copy mode is now the primary recommendation for team portability.
- Symlink mode remains available for local development convenience.

## [0.0.2] - 2026-04-24

### Added
- Added Python runtime guidance files under `.github` for workspace-native discovery:
  - `.github/instructions/enterprise-python-checklist.instructions.md`
  - `.github/instructions/python-code-generation.instructions.md`
  - `.github/prompts/python-system.prompt.md`
- Added canonical Python guidance sources under `config/python`:
  - `config/python/instructions/enterprise-python-checklist.md`
  - `config/python/instructions/python-code-generation-instructions.md`
  - `config/python/prompts/python-system.prompt.md`
- Added first-time Python onboarding guide:
  - `config/python/README.md`
- Added symlink sync script for guidance distribution:
  - `scripts/sync_python_guidance_symlinks.sh`

### Changed
- Updated root `README.md` with Python onboarding pointer and release metadata references.
- Updated Python prompt references to canonical `config/python/instructions` paths.

### Notes
- Current distribution model supports symlink-based synchronization for downstream repositories.
- Python is the first enabled language; Java, dotnet, and additional language packs are planned next.

## [0.0.1] - 2026-04-24

### Added
- Initial repository baseline with:
  - root governance files (`AGENTS.md`, policy/warning docs)
  - language config directories (`config/python`, `config/java-spring`, `config/dotnet-minimal`, `config/nextjs`, `config/rust-axum`)
  - reusable skill directory structure under `skill/`
=======
## [v0.1.1] - 2026-04-26
### Added
- LoggingMiddleware implementation for structured logging.
- Unit tests for LoggingMiddleware.
- Documentation for LoggingMiddleware in README.md.
>>>>>>> 5333cd9 (Initialize repository with LoggingMiddleware, tests, documentation, changelog, and release notes)
