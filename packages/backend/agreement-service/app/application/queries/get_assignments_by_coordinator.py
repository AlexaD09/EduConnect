from __future__ import annotations
from typing import List, Dict, Any
from app.domain.ports.assignment_repository import AssignmentRepository
from app.domain.ports.user_service_port import UserServicePort

class GetAssignmentsByCoordinatorUseCase:
    def __init__(self, assignment_repo: AssignmentRepository, user_service: UserServicePort):
        self.assignment_repo = assignment_repo
        self.user_service = user_service

    def execute(self, coordinator_id: int) -> List[Dict[str, Any]]:
        coordinator = self.user_service.get_user(coordinator_id)
        if not coordinator:
            return []
        agreement_id = coordinator.get("agreement_id")
        if not agreement_id:
            return []

        assignments = self.assignment_repo.list_by_agreement_id(agreement_id)

        result: List[Dict[str, Any]] = []
        for a in assignments:
            student = self.user_service.get_student(a["student_id"])
            if student:
                result.append({
                    "student_id": a["student_id"],
                    "student_username": student.get("username", f"Student {a['student_id']}"),
                    "city": student.get("city", "Unknown"),
                })
            else:
                result.append({
                    "student_id": a["student_id"],
                    "student_username": f"Student {a['student_id']}",
                    "city": "Unknown",
                })
        return result
