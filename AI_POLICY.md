# AI Usage Policy

## Purpose
Define rules for responsible use of AI-assisted content in this repository.

## Scope
Applies to all source files, templates, documentation, scripts, and generated assets.

## Policy Requirements
- Always disclose AI-assisted changes in pull requests when applicable.
- Require human review for every AI-assisted change before merge.
- Never commit secrets, credentials, tokens, keys, or sensitive personal data.
- Verify correctness with tests or equivalent validation before release.
- Treat AI outputs as suggestions, not authoritative facts.
- Ensure third-party content and code comply with licensing obligations.

## Security and Compliance
- Run appropriate security checks before release.
- Remove or rewrite unsafe code patterns discovered during review.
- Reject AI-generated changes that bypass governance, audit, or approval controls.

## Quality Controls
- Keep changes minimal, testable, and traceable.
- Add provenance notes for significant AI-assisted artifacts.
- Prefer reproducible templates over one-off generated outputs.

## Incident Handling
If AI-generated content causes or contributes to a defect or risk event:
- Open an incident record with scope and impact.
- Revert or patch affected artifacts.
- Add or update tests and guardrails to prevent recurrence.

## Enforcement
Maintainers may block or revert any contribution that violates this policy.
