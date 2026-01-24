from __future__ import annotations
from typing import Optional, List, Dict, Any
from sqlalchemy.orm import Session
from app.domain.ports.assignment_repository import AssignmentRepository
from app.infrastructure.persistence.models import Assignment

class AssignmentRepositoryPostgres(AssignmentRepository):
    def __init__(self, db: Session):
        self.db = db

    def get_by_student_id(self, student_id: int) -> Optional[dict]:
        a = self.db.query(Assignment).filter(Assignment.student_id == student_id).first()
        if not a:
            return None
        return {"id": a.id, "student_id": a.student_id, "agreement_id": a.agreement_id, "tutor_id": a.tutor_id}

    def create(self, student_id: int, agreement_id: int, tutor_id: int) -> dict:
        a = Assignment(student_id=student_id, agreement_id=agreement_id, tutor_id=tutor_id)
        self.db.add(a)
        self.db.commit()
        self.db.refresh(a)
        return {"id": a.id, "student_id": a.student_id, "agreement_id": a.agreement_id, "tutor_id": a.tutor_id}

    def list_by_agreement_id(self, agreement_id: int) -> List[dict]:
        rows = self.db.query(Assignment).filter(Assignment.agreement_id == agreement_id).all()
        return [{"id": r.id, "student_id": r.student_id, "agreement_id": r.agreement_id, "tutor_id": r.tutor_id} for r in rows]
