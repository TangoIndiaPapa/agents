"""
Pydantic models for StateManager subsystem.
Follows enterprise documentation and type safety standards.
"""
from typing import List, Optional, Dict, Any
from pydantic import BaseModel, Field
from datetime import datetime

class AuditEntry(BaseModel):
    sequence: int
    timestamp: datetime
    actor: str
    action: str
    phase: int
    checkpoint: str
    change: str
    prev_hash: str
    hash: str

class ProgressiveDisclosure(BaseModel):
    summary: str
    details: Optional[str] = None
    full: Optional[str] = None

class PhaseState(BaseModel):
    phase: int
    checkpoint: str
    deliverables: List[str]
    tests_passed: int
    coverage: float
    status: str
    progressive_disclosure: ProgressiveDisclosure
    audit_entries: List[AuditEntry] = Field(default_factory=list)

class AgentState(BaseModel):
    phases: Dict[int, PhaseState]
    last_checkpoint: Optional[str] = None
    updated_at: datetime
    version: str
    notes: Optional[str] = None
