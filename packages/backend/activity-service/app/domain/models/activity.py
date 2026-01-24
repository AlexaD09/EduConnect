from __future__ import annotations
from dataclasses import dataclass
from datetime import datetime
from typing import Optional

@dataclass(frozen=True)
class Activity:
    id: int
    student_id: int
    agreement_id: int
    description: str
    entry_photo_path: Optional[str]
    exit_photo_path: Optional[str]
    status: str
    created_at: datetime
    observations: Optional[str] = None
