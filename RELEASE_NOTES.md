# Release Notes

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