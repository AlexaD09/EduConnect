from __future__ import annotations
from typing import Dict, Any
from app.domain.ports.tutor_repository import TutorRepository

class GetTutorUseCase:
    def __init__(self, tutor_repo: TutorRepository):
        self.tutor_repo = tutor_repo

    def execute(self, tutor_id: int) -> Dict[str, Any]:
        tutor = self.tutor_repo.get_by_id(tutor_id)
        if not tutor:
            raise KeyError("Tutor not found")
        return {
            "id": tutor["id"],
            "full_name": tutor["full_name"],
            "contact_email": tutor.get("contact_email"),
            "contact_phone": tutor.get("contact_phone"),
            "city": tutor.get("city"),
        }
