#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  create_python_repo.sh <repo-path> [agents-root]

Examples:
  ./scripts/create_python_repo.sh /workspaces/my-new-python-repo
  ./scripts/create_python_repo.sh /workspaces/my-new-python-repo /workspaces/agents
EOF
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 1
fi

repo_path="$1"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
default_agents_root="$(cd "${script_dir}/.." && pwd)"
agents_root="${2:-$default_agents_root}"

repo_name="$(basename "$repo_path")"
package_name="$(echo "$repo_name" | tr '-' '_' | tr -cd '[:alnum:]_')"

mkdir -p "$repo_path/src/$package_name" "$repo_path/tests" "$repo_path/.github/workflows"

if [[ ! -d "$repo_path/.git" ]]; then
  git init "$repo_path" >/dev/null
fi

if [[ ! -f "$repo_path/README.md" ]]; then
  cat >"$repo_path/README.md" <<EOF
# $repo_name

Python project scaffold generated from the agents repository baseline.

## Setup

\`\`\`bash
export PATH="\$HOME/.local/bin:\$PATH"
uv venv .venv
source .venv/bin/activate
uv sync
uv run pytest -v
\`\`\`
EOF
fi

if [[ ! -f "$repo_path/.gitignore" ]]; then
  cat >"$repo_path/.gitignore" <<'EOF'
.venv/
__pycache__/
.pytest_cache/
*.pyc
dist/
build/
.DS_Store
EOF
fi

if [[ ! -f "$repo_path/pyproject.toml" ]]; then
  cat >"$repo_path/pyproject.toml" <<EOF
[project]
name = "$repo_name"
version = "0.1.0"
description = "Python scaffold created from agents baseline"
readme = "README.md"
requires-python = ">=3.12"
dependencies = []

[dependency-groups]
dev = [
  "pytest>=8.3.0,<9.0.0",
  "pytest-asyncio>=0.24.0,<1.0.0",
]

[tool.pytest.ini_options]
pythonpath = ["src"]
asyncio_mode = "auto"
addopts = "-q"
EOF
fi

if [[ ! -f "$repo_path/src/$package_name/__init__.py" ]]; then
  echo '"""Project package."""' >"$repo_path/src/$package_name/__init__.py"
fi

if [[ ! -f "$repo_path/tests/test_smoke.py" ]]; then
  cat >"$repo_path/tests/test_smoke.py" <<'EOF'
def test_smoke() -> None:
    assert True
EOF
fi

if [[ ! -f "$repo_path/.github/workflows/ci.yml" ]]; then
  cat >"$repo_path/.github/workflows/ci.yml" <<'EOF'
name: CI

on:
  pull_request:
  push:
    branches:
      - main

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      - name: Install uv
        run: pip install uv
      - name: Sync dependencies
        run: uv sync
      - name: Run tests
        run: uv run pytest -v
EOF
fi

"$script_dir/sync_guidance_files.sh" python "$repo_path" "$agents_root" copy

echo "Created Python repository scaffold at: $repo_path"
echo "Guidance files copied into: $repo_path/.github"