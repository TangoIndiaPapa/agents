# Python Developer Onboarding

Use this guide if you are new to VS Code, GitHub Copilot, or Claude workflows and want to start Python development after cloning this repository.

## What This Repo Provides

This repository provides shared AI coding guidance for teams.

Primary Python guidance files:
- `config/python/prompts/python-system.prompt.md`
- `config/python/instructions/enterprise-python-checklist.md`
- `config/python/instructions/python-code-generation-instructions.md`

Repo-local runtime mirrors used by workspace-aware tools:
- `.github/prompts/python-system.prompt.md`
- `.github/instructions/enterprise-python-checklist.instructions.md`
- `.github/instructions/python-code-generation.instructions.md`

## Step 1: Install Required Tools

Install:
1. VS Code
2. Git
3. Python 3.12+
4. `uv` package manager

Optional but common:
1. Docker Desktop (if your team uses Dev Containers)

## Step 2: Clone And Open The Repo

```bash
git clone <your-agents-repo-url> agents
cd agents
code .
```

If prompted, trust the workspace.

## Step 2.1: Create New Python Repo With Guidance (Recommended)

When creating a new Python repo for team work, use the agents bootstrap script so guidance files are copied at creation time:

```bash
cd /workspaces/agents
./scripts/create_python_fastapi_service.sh /workspaces/<new-python-service>
```

Use that command when you want a production-oriented FastAPI service with enterprise defaults built in.

If you only need a minimal Python starter repo, use:

```bash
cd /workspaces/agents
./scripts/create_python_repo.sh /workspaces/<new-python-repo>
```

Both commands copy Python guidance into:
- `<new-python-repo>/.github/instructions`
- `<new-python-repo>/.github/prompts`

The enterprise FastAPI scaffold also includes:
- JWT auth and RBAC baseline
- rate limiting, trusted host validation, CORS, and security headers
- structured logging and OpenTelemetry hooks
- SQLite example domain service and tests
- GitHub Actions CI workflow

## Step 3: Install VS Code Extensions

Install these extensions in VS Code:
1. GitHub Copilot
2. GitHub Copilot Chat
3. Python (Microsoft)
4. Pylance
5. Ruff

If your team uses Claude in VS Code, install and sign in to the approved Claude extension or client your organization standardizes on.

## Step 4: Authenticate AI Tools

For GitHub Copilot:
1. Sign in with your GitHub account.
2. Confirm Copilot is enabled for this workspace.

For Claude workflow:
1. Sign in using your team-approved method.
2. Confirm the tool can access the current workspace.

## Step 5: Verify Workspace Guidance Is Active

In Copilot Chat or your coding assistant chat, ask:
- "What Python guidance files are active in this repo?"

Expected references should include Python prompt/instruction files under:
- `.github/prompts`
- `.github/instructions`
- `config/python`

## Step 6: Set Up Python Environment

From the repository root:

```bash
export PATH="$HOME/.local/bin:$PATH"
uv venv .venv
source .venv/bin/activate
python -V
```

If you are working on a Python project in another repo, repeat environment setup in that project repo.

## Step 7: First-Time Python Development Workflow

When generating Python code with AI in this workspace:
1. Follow `config/python/prompts/python-system.prompt.md` as the baseline behavior.
2. Apply enterprise requirements from `config/python/instructions/enterprise-python-checklist.md`.
3. Apply coding/test execution rules from `config/python/instructions/python-code-generation-instructions.md`.
4. Run tests using `uv run pytest`.

## Step 8: Dev Container (If Used By Your Team)

If your target project has a Dev Container:
1. Open the target project in VS Code.
2. Run "Dev Containers: Reopen in Container".
3. Re-authenticate Copilot/Claude if prompted.
4. Verify Python interpreter and workspace guidance files again.

## Troubleshooting

### Copilot or Claude does not appear to follow Python guidance
- Confirm you opened the correct repository root.
- Confirm `.github/instructions` and `.github/prompts` exist in the workspace.
- Confirm you are signed in and the extension is enabled for this workspace.

### Python interpreter is wrong
- Select interpreter from `.venv/bin/python`.
- Re-run `source .venv/bin/activate` in terminal.

### uv command not found
- Ensure `uv` is installed.
- Run `export PATH="$HOME/.local/bin:$PATH"` and retry.

## Team Scaling Notes

Python is the first language enabled in this repository.
Future language onboarding should follow the same pattern:
1. Add language-specific guidance under `config/<language>/`.
2. Add runtime mirrors under `.github/instructions` and `.github/prompts` as needed.
3. Add a language README under `config/<language>/README.md`.
4. Add/create a language-specific bootstrap creation script in `scripts/`.
