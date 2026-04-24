# Agents Repository

Current version: 0.0.8

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
- Latest release: `0.0.8` (language-neutral root policy and Python guidance redistribution)
- Highlights:
	- Reworked `AGENTS.md` into a concise, language-neutral root policy.
	- Moved Python-specific architecture guidance into `config/python` instruction and prompt files.
	- Added `CLAUDE.md` as a compatibility import pointing at the root `AGENTS.md`.
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
