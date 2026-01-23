from __future__ import annotations
from typing import Optional

from app.domain.ports.activity_repository import ActivityRepository

class UpdateActivityStatusCommand:
    def __init__(self, activity_repo: ActivityRepository):
        self._activity_repo = activity_repo

    def execute(self, activity_id: int, status: str, observations: Optional[str] = None) -> None:
        updated = self._activity_repo.update_status(activity_id=activity_id, status=status, observations=observations)
        if not updated:
            raise LookupError("Activity not found")
