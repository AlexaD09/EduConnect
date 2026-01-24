from __future__ import annotations
from typing import List
from app.domain.models.activity import Activity
from app.domain.ports.activity_repository import ActivityRepository

class GetStudentActivitiesQuery:
    def __init__(self, activity_repo: ActivityRepository):
        self._activity_repo = activity_repo

    def execute(self, student_id: int) -> List[Activity]:
        return self._activity_repo.list_by_student(student_id)
