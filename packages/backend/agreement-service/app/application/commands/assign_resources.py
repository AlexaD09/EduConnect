from __future__ import annotations
from typing import Dict, Any
import random
from app.domain.ports.assignment_repository import AssignmentRepository
from app.domain.ports.tutor_repository import TutorRepository
from app.domain.ports.user_service_port import UserServicePort

class AssignResourcesUseCase:
    def __init__(self, assignment_repo: AssignmentRepository, tutor_repo: TutorRepository, user_service: UserServicePort):
        self.assignment_repo = assignment_repo
        self.tutor_repo = tutor_repo
        self.user_service = user_service

    def execute(self, student_id: int) -> Dict[str, Any]:
        # 1) ciudad del estudiante (externo)
        city = self.user_service.get_student_city(student_id)

        # 2) convenios disponibles (externo)
        agreements = self.user_service.get_agreements_by_city(city)
        if not agreements:
            raise ValueError(f"No hay convenios en {city}")
        agreement_id = agreements[0]["id"]

        # 3) tutores por ciudad (local)
        tutors = self.tutor_repo.list_by_city(city)
        if not tutors:
            raise ValueError(f"No hay tutores disponibles en {city}")

        tutor = random.choice(tutors)

        # 4) persistir asignación
        created = self.assignment_repo.create(student_id=student_id, agreement_id=agreement_id, tutor_id=tutor["id"])
        return {
            "student_id": created["student_id"],
            "agreement_id": created["agreement_id"],
            "tutor_id": created["tutor_id"],
            "tutor_name": tutor.get("full_name"),
        }
