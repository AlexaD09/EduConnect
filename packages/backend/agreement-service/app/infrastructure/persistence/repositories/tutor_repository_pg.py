from __future__ import annotations
from typing import Optional, List, Dict, Any
from sqlalchemy.orm import Session
from app.domain.ports.tutor_repository import TutorRepository
from app.infrastructure.persistence.models import Tutor

class TutorRepositoryPostgres(TutorRepository):
    def __init__(self, db: Session):
        self.db = db

    def get_by_id(self, tutor_id: int) -> Optional[dict]:
        t = self.db.query(Tutor).filter(Tutor.id == tutor_id).first()
        if not t:
            return None
        return {
            "id": t.id,
            "full_name": t.full_name,
            "id_number": t.id_number,
            "city": t.city,
            "contact_email": t.contact_email,
            "contact_phone": t.contact_phone,
        }

    def list_by_city(self, city: str) -> List[dict]:
        rows = self.db.query(Tutor).filter(Tutor.city == city).all()
        return [{
            "id": r.id,
            "full_name": r.full_name,
            "id_number": r.id_number,
            "city": r.city,
            "contact_email": r.contact_email,
            "contact_phone": r.contact_phone,
        } for r in rows]
