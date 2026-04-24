# Release Notes

## 0.0.8 - 2026-04-24

This release simplifies the root agent policy and moves Python-specific guidance to the Python configuration surfaces where it belongs.

### Highlights
- Reworked `AGENTS.md` into a concise, language-neutral root policy.
- Moved Python-specific architecture and documentation guidance into `config/python/instructions/python-code-generation-instructions.md`.
- Updated the Python compatibility prompt to explicitly direct Python-only guidance away from the root policy.
- Added `CLAUDE.md` as a compatibility import that references `AGENTS.md`.

### Validation
- Reviewed the resulting diffs for `AGENTS.md`, the Python instruction file, the Python prompt file, and `CLAUDE.md`.
- Verified that the `.github` runtime mirror files already matched the updated Python guidance.

### Affected Areas
- root repository agent policy in `AGENTS.md`
- Python instruction and prompt guidance under `config/python/`
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