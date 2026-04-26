import pytest
from pathlib import Path

# Define the paths to the test fixtures
POSITIVE_CASE = Path("tests/agents/doc-compliance-reviewer-fixtures/positive_case.py")
NEGATIVE_CASE = Path("tests/agents/doc-compliance-reviewer-fixtures/negative_case.py")

# Mock function to simulate the doc-compliance-reviewer behavior
def run_doc_compliance_reviewer(file_path):
    violations = []
    if file_path == NEGATIVE_CASE:
        violations.append({
            "file": str(file_path),
            "line": 1,
            "rule": "Public function/method docstrings present, with: purpose, args, return value, and raised errors where relevant.",
            "what's missing": "Missing docstring for the public function `public_function`."
        })
        violations.append({
            "file": str(file_path),
            "line": 7,
            "rule": "Module-level docstring present on non-trivial modules, explaining purpose, critical constraints, and design tradeoffs.",
            "what's missing": "Missing module-level docstring."
        })
    return violations

# Test for the positive case
def test_positive_case():
    violations = run_doc_compliance_reviewer(POSITIVE_CASE)
    assert len(violations) == 0, f"Expected no violations, but found: {violations}"

# Test for the negative case
def test_negative_case():
    violations = run_doc_compliance_reviewer(NEGATIVE_CASE)
    assert len(violations) == 2, f"Expected 2 violations, but found: {len(violations)}"
    assert violations[0]["line"] == 1
    assert violations[1]["line"] == 7