"""
StateManager: Handles state persistence, progressive disclosure, and checkpointing for the harness kernel.
Follows enterprise documentation and auditability standards.
"""
import json
import hashlib
from pathlib import Path
from datetime import datetime
from typing import Optional
from .models import AgentState, PhaseState, AuditEntry, ProgressiveDisclosure
from pydantic import ValidationError

class StateManager:
    """
    Manages state persistence and progressive disclosure for the harness kernel.
    - Reads AGENTS.md as source of truth
    - Loads and saves state to .agent-state/
    - Supports checkpointing and hash-chained audit logging
    """
    def __init__(self, agents_md_path: Path, state_dir: Path, version: str):
        self.agents_md_path = agents_md_path
        self.state_dir = state_dir
        self.version = version
        self.state_file = self.state_dir / "agent_state.json"
        self.state_dir.mkdir(parents=True, exist_ok=True)

    def load_from_agents_md(self) -> dict:
        """Parse AGENTS.md and extract state schema (stub: implement frontmatter parsing)."""
        with open(self.agents_md_path, "r") as f:
            content = f.read()
        # TODO: Parse frontmatter or structured block
        return {"raw": content}

    def load_phase_state(self, phase: int) -> Optional[PhaseState]:
        """Load phase state from agent_state.json."""
        if not self.state_file.exists():
            return None
        with open(self.state_file, "r") as f:
            data = json.load(f)
        try:
            agent_state = AgentState(**data)
            return agent_state.phases.get(phase)
        except ValidationError:
            return None

    def save_phase_state(self, phase: int, state: PhaseState) -> None:
        """Persist phase state with hash chaining."""
        agent_state = self._load_or_init_agent_state()
        agent_state.phases[phase] = state
        agent_state.last_checkpoint = state.checkpoint
        agent_state.updated_at = datetime.utcnow()
        with open(self.state_file, "w") as f:
            f.write(agent_state.model_dump_json(indent=2, exclude_none=True))

    def get_progressive_disclosure(self, phase: int, layer: int) -> Optional[str]:
        """Return context at specific detail level (1=summary, 2=details, 3=full)."""
        phase_state = self.load_phase_state(phase)
        if not phase_state:
            return None
        pd = phase_state.progressive_disclosure
        if layer == 1:
            return pd.summary
        elif layer == 2:
            return pd.details or pd.summary
        elif layer == 3:
            return pd.full or pd.details or pd.summary
        return None

    def update_checkpoint(self, phase: int, checkpoint_name: str, artifacts: dict) -> None:
        """Record completed checkpoint and update audit log."""
        phase_state = self.load_phase_state(phase)
        if not phase_state:
            raise ValueError("Phase state not found")
        # Create audit entry
        prev_hash = phase_state.audit_entries[-1].hash if phase_state.audit_entries else "0" * 64
        entry = AuditEntry(
            sequence=len(phase_state.audit_entries) + 1,
            timestamp=datetime.utcnow(),
            actor="Agent-Copilot",
            action="CheckpointUpdate",
            phase=phase,
            checkpoint=checkpoint_name,
            change=str(artifacts),
            prev_hash=prev_hash,
            hash=""
        )
        # Compute hash
        entry.hash = hashlib.sha256((prev_hash + json.dumps(artifacts, sort_keys=True)).encode()).hexdigest()
        phase_state.audit_entries.append(entry)
        phase_state.checkpoint = checkpoint_name
        self.save_phase_state(phase, phase_state)

    def _load_or_init_agent_state(self) -> AgentState:
        if self.state_file.exists():
            with open(self.state_file, "r") as f:
                data = json.load(f)
            try:
                return AgentState(**data)
            except ValidationError:
                pass
        # Initialize new AgentState
        return AgentState(phases={}, updated_at=datetime.utcnow(), version=self.version)
