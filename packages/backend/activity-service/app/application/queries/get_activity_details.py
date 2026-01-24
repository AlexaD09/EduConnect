from __future__ import annotations
from app.domain.models.activity import Activity
from app.domain.ports.activity_repository import ActivityRepository

class GetActivityDetailsQuery:
    def __init__(self, activity_repo: ActivityRepository):
        self._activity_repo = activity_repo

    def execute(self, activity_id: int) -> Activity:
        activity = self._activity_repo.get_by_id(activity_id)
        if not activity:
            raise LookupError("Activity not found")
        return activity
