"""
Unit tests for the LoggingMiddleware class.
"""

import pytest
from agents_harness.logging_middleware import LoggingMiddleware
from unittest.mock import patch

@pytest.fixture
def logging_middleware():
    return LoggingMiddleware()

def test_log_info(logging_middleware):
    with patch("logging.Logger.info") as mock_info:
        logging_middleware.log_info("Test info message")
        mock_info.assert_called_once_with("Test info message")

def test_log_warning(logging_middleware):
    with patch("logging.Logger.warning") as mock_warning:
        logging_middleware.log_warning("Test warning message")
        mock_warning.assert_called_once_with("Test warning message")

def test_log_error(logging_middleware):
    with patch("logging.Logger.error") as mock_error:
        logging_middleware.log_error("Test error message")
        mock_error.assert_called_once_with("Test error message")

def test_log_debug(logging_middleware):
    with patch("logging.Logger.debug") as mock_debug:
        logging_middleware.log_debug("Test debug message")
        mock_debug.assert_called_once_with("Test debug message")