# Changelog

All notable changes to this repository are documented in this file.

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