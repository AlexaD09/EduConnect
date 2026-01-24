from pydantic import BaseModel, Field
from datetime import datetime
from typing import Any, Dict, Optional


class AuditRecord(BaseModel):
    event_type: str
    entity_type: str
    entity_id: str

    actor_username: Optional[str] = None
    actor_id: Optional[str] = None

    previous_state: Optional[Dict[str, Any]] = None
    new_state: Optional[Dict[str, Any]] = None

    payload: Dict[str, Any] = Field(default_factory=dict)
    occurred_at: datetime = Field(default_factory=datetime.utcnow)
