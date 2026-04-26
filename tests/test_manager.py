"""
Tests for StateManager (Phase 0.1).
Covers AGENTS.md parsing, state persistence, recovery, progressive disclosure, checkpoint updates, and hash verification.
"""
import tempfile
from pathlib import Path
from datetime import datetime
from agents_harness.state.manager import StateManager
from agents_harness.state.models import PhaseState, ProgressiveDisclosure
import os

def test_state_manager_lifecycle():
    with tempfile.TemporaryDirectory() as tmpdir:
        agents_md = Path(tmpdir) / "AGENTS.md"
        state_dir = Path(tmpdir) / ".agent-state"
        agents_md.write_text("---\nversion: 1.0\n---\n# AGENTS.md stub\n")
        version = "0.1.0"
        sm = StateManager(agents_md, state_dir, version)

        # Test AGENTS.md parsing
        parsed = sm.load_from_agents_md()
        assert "raw" in parsed

        # Test initial state persistence
        pd = ProgressiveDisclosure(summary="s", details="d", full="f")
        phase_state = PhaseState(
            phase=0,
            checkpoint="init",
            deliverables=["foo.py"],
            tests_passed=1,
            coverage=100.0,
            status="Complete",
            progressive_disclosure=pd,
        )
        sm.save_phase_state(0, phase_state)
        loaded = sm.load_phase_state(0)
        assert loaded is not None
        assert loaded.checkpoint == "init"

        # Test progressive disclosure
        assert sm.get_progressive_disclosure(0, 1) == "s"
        assert sm.get_progressive_disclosure(0, 2) == "d"
        assert sm.get_progressive_disclosure(0, 3) == "f"

        # Test checkpoint update and audit log
        sm.update_checkpoint(0, "ckpt1", {"foo": "bar"})
        loaded2 = sm.load_phase_state(0)
        assert loaded2.audit_entries
        assert loaded2.audit_entries[-1].checkpoint == "ckpt1"
        assert len(loaded2.audit_entries[-1].hash) == 64

        # Test recovery from missing state file
        os.remove(sm.state_file)
        assert sm.load_phase_state(0) is None
