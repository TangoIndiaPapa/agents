<<<<<<< HEAD
# Agents Repository

Current version: 0.1.0

This repository separates agent guidance into two domains:
- config: language/runtime-specific AGENTS.md blueprints and templates
- skill: language-agnostic, reusable SKILL.md capabilities

## Structure
- config/: horizontal language/runtime defaults
- skill/: vertical capabilities that apply across stacks

## New Developer Onboarding
- Python first-time setup guide: [config/python/README.md](config/python/README.md)

## Repo Creation Workflow (Preferred)
For new repositories, create project scaffolding and copy guidance files at creation time.

Recommended commands:
1. `./scripts/create_python_fastapi_service.sh <new-service-path>` for production-grade FastAPI services
2. `./scripts/create_python_repo.sh <new-repo-path>` for minimal starter repos

The enterprise service generator creates a production-oriented FastAPI scaffold with auth, RBAC, rate limits, security middleware, logging, tracing hooks, tests, and CI. The minimal repo generator remains available when you only need a starter layout plus copied guidance.

If you need to refresh guidance later:
1. Copy mode (recommended for portability):
	`./scripts/sync_guidance_files.sh python <target-repo> [agents-root] copy`
2. Symlink mode (local/dev convenience only):
	`./scripts/sync_guidance_symlinks.sh python <target-repo> [agents-root]`

## Release Notes
- Latest release: `0.1.0` (context integrity & memory management controls)
- Highlights:
        - Added robust, auditable context integrity and memory management controls to assessment and plan files.
        - Enforced persistent structured memory, context window management, goal/plan traceability, automated consistency checks, audit logging, and human-in-the-loop verification for all phases.
- Published release notes: [RELEASE_NOTES.md](RELEASE_NOTES.md)
- Latest changelog: [CHANGELOG.md](CHANGELOG.md)
- Version file: [VERSION](VERSION)

## Release Discipline (Required)
For every release, keep `VERSION`, changelog, release notes, and git tag in sync.

Required sequence:
1. Decide next semantic version (`MAJOR.MINOR.PATCH`).
2. Update [VERSION](VERSION) with the exact release version.
3. Add a new top section in [CHANGELOG.md](CHANGELOG.md) for that version with date, added/changed/fixed details.
4. Ensure README references remain accurate (onboarding, release links, and any version text).
5. Commit release metadata changes together in one commit.
6. Create an annotated git tag with the same version from [VERSION](VERSION), for example `v0.0.2`.
7. Publish release notes using the matching changelog section.

Consistency checks before tagging:
1. [VERSION](VERSION) value matches changelog heading version.
2. Changelog version matches git tag exactly (except optional `v` prefix on the tag).
3. Release notes summary references the same version and key changes.
4. No release is published without a matching changelog entry.

## Consumption Guidance
Preferred distribution order:
1. git submodule or git subtree (version-pinned)
2. bootstrap CLI/script with copied guidance files
3. AGENTS.md import when supported
4. symlink as last resort for local development only

## Rules
- Do not place language-specific files under skill
- Skill folder name must match SKILL.md frontmatter name
- Keep skills one level deep under skill/
=======
## LoggingMiddleware

The `LoggingMiddleware` class provides structured logging for the harness kernel. It supports logging at various levels:
- Info
- Warning
- Error
- Debug

### Usage

```python
from agents_harness.logging_middleware import LoggingMiddleware

logger = LoggingMiddleware()
logger.log_info("This is an info message.")
logger.log_warning("This is a warning message.")
logger.log_error("This is an error message.")
logger.log_debug("This is a debug message.")
```
>>>>>>> 5333cd9 (Initialize repository with LoggingMiddleware, tests, documentation, changelog, and release notes)
