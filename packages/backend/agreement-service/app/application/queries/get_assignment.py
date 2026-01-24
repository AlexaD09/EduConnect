from __future__ import annotations
from typing import Dict, Any
from app.domain.ports.assignment_repository import AssignmentRepository

class GetAssignmentUseCase:
    def __init__(self, assignment_repo: AssignmentRepository):
        self.assignment_repo = assignment_repo

    def execute(self, student_id: int) -> Dict[str, Any]:
        assignment = self.assignment_repo.get_by_student_id(student_id)
        if assignment:
            return {
                "has_assignment": True,
                "student_id": assignment["student_id"],
                "agreement_id": assignment["agreement_id"],
                "tutor_id": assignment["tutor_id"],
            }
        return {"has_assignment": False}
