"""
Unit tests for the ValidationMiddleware class.
"""

import pytest
from agents_harness.validation_middleware import ValidationMiddleware
from unittest.mock import patch, MagicMock

def test_run_tool_success():
    middleware = ValidationMiddleware()
    with patch("subprocess.run") as mock_run:
        mock_run.return_value = MagicMock(returncode=0, stdout="Success", stderr="")
        output = middleware.run_tool("ruff", ["--version"])
        assert output == "Success"

def test_run_tool_failure():
    middleware = ValidationMiddleware()
    with patch("subprocess.run") as mock_run:
        mock_run.return_value = MagicMock(returncode=1, stderr="Error")
        with pytest.raises(RuntimeError, match="ruff failed: Error"):
            middleware.run_tool("ruff", ["--version"])

def test_run_tool_unsupported():
    middleware = ValidationMiddleware()
    with pytest.raises(ValueError, match="Tool unsupported_tool is not supported."):
        middleware.run_tool("unsupported_tool", [])

def test_validate_code():
    middleware = ValidationMiddleware()
    with patch("agents_harness.validation_middleware.ValidationMiddleware.run_tool") as mock_run_tool:
        mock_run_tool.side_effect = lambda tool, args: f"{tool} output"
        results = middleware.validate_code(["test.py"])
        assert results == {
            "ruff": "ruff output",
            "mypy": "mypy output",
            "pytest": "pytest output"
        }