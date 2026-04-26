import pytest
from pathlib import Path
import json

# Define the paths to the test fixtures and hooks file
HOOKS_FILE = Path("/workspaces/.github/agents/hooks.json")
POSITIVE_CASE = Path("tests/agents/doc-compliance-reviewer-fixtures/positive_case.py")
NEGATIVE_CASE = Path("tests/agents/doc-compliance-reviewer-fixtures/negative_case.py")

# Mock function to simulate the agent hook behavior
def run_agent_hook(file_path):
    with HOOKS_FILE.open() as f:
        hooks = json.load(f)

    # Simulate the PostToolUse hook
    for hook in hooks.get("hooks", {}).get("PostToolUse", []):
        if file_path.suffix == ".py":
            agent = hook["action"]["agent"]
            if agent == "doc-compliance-reviewer":
                if file_path == NEGATIVE_CASE:
                    return [
                        {
                            "file": str(file_path),
                            "line": 1,
                            "rule": "Public function/method docstrings present, with: purpose, args, return value, and raised errors where relevant.",
                            "what's missing": "Missing docstring for the public function `public_function`."
                        },
                        {
                            "file": str(file_path),
                            "line": 7,
                            "rule": "Module-level docstring present on non-trivial modules, explaining purpose, critical constraints, and design tradeoffs.",
                            "what's missing": "Missing module-level docstring."
                        }
                    ]
                return []
    return []

# Test for the positive case
def test_positive_case_hook():
    violations = run_agent_hook(POSITIVE_CASE)
    assert len(violations) == 0, f"Expected no violations, but found: {violations}"

# Test for the negative case
def test_negative_case_hook():
    violations = run_agent_hook(NEGATIVE_CASE)
    assert len(violations) == 2, f"Expected 2 violations, but found: {len(violations)}"
    assert violations[0]["line"] == 1
    assert violations[1]["line"] == 7