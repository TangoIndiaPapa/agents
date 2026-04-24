# Agents Repository

This repository separates agent guidance into two domains:
- config: language/runtime-specific AGENTS.md blueprints and templates
- skill: language-agnostic, reusable SKILL.md capabilities

## Structure
- config/: horizontal language/runtime defaults
- skill/: vertical capabilities that apply across stacks

## Consumption Guidance
Preferred distribution order:
1. git submodule or git subtree (version-pinned)
2. bootstrap CLI/script
3. AGENTS.md import when supported
4. symlink as last resort

## Rules
- Do not place language-specific files under skill
- Skill folder name must match SKILL.md frontmatter name
- Keep skills one level deep under skill/
