"""
Unit tests for the StateManager class.
"""

import pytest
from pathlib import Path
from agents_harness.state_manager import StateManager
import json

@pytest.fixture
def state_manager(tmp_path):
    agents_md = tmp_path / "AGENTS.md"
    state_dir = tmp_path / ".agent-state"
    agents_md.write_text("# AGENTS.md\nTest content.")
    return StateManager(agents_md_path=str(agents_md), state_dir=str(state_dir))

def test_read_agents_md(state_manager):
    content = state_manager.read_agents_md()
    assert content == "# AGENTS.md\nTest content."

def test_write_and_read_state(state_manager):
    data = {"key": "value"}
    state_manager.write_state("test.json", data)

    read_data = state_manager.read_state("test.json")
    assert read_data == data

def test_read_agents_md_file_not_found():
    with pytest.raises(FileNotFoundError):
        StateManager("nonexistent.md", ".agent-state").read_agents_md()

def test_read_state_file_not_found(state_manager):
    with pytest.raises(FileNotFoundError):
        state_manager.read_state("nonexistent.json")