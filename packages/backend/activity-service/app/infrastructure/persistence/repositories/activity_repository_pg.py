from __future__ import annotations
from typing import List, Optional
from sqlalchemy.orm import Session

from app.domain.models.activity import Activity as ActivityDomain
from app.domain.ports.activity_repository import ActivityRepository
from app.infrastructure.persistence.models.activity_orm import Activity as ActivityORM

class ActivityRepositoryPostgres(ActivityRepository):
    def __init__(self, db: Session):
        self._db = db

    def create(
        self,
        student_id: int,
        agreement_id: int,
        description: str,
        entry_photo_path: str,
        exit_photo_path: str,
    ) -> ActivityDomain:
        row = ActivityORM(
            student_id=student_id,
            agreement_id=agreement_id,
            description=description,
            entry_photo_path=entry_photo_path,
            exit_photo_path=exit_photo_path,
        )
        self._db.add(row)
        self._db.commit()
        self._db.refresh(row)
        return self._to_domain(row)

    def list_by_student(self, student_id: int) -> List[ActivityDomain]:
        rows = self._db.query(ActivityORM).filter(ActivityORM.student_id == student_id).all()
        return [self._to_domain(r) for r in rows]

    def list_pending_by_agreement(self, agreement_id: int) -> List[ActivityDomain]:
        rows = (
            self._db.query(ActivityORM)
            .filter(ActivityORM.agreement_id == agreement_id, ActivityORM.status == "PENDING")
            .all()
        )
        return [self._to_domain(r) for r in rows]

    def get_by_id(self, activity_id: int) -> Optional[ActivityDomain]:
        row = self._db.query(ActivityORM).filter(ActivityORM.id == activity_id).first()
        return self._to_domain(row) if row else None

    def update_status(self, activity_id: int, status: str, observations: Optional[str] = None) -> bool:
        row = self._db.query(ActivityORM).filter(ActivityORM.id == activity_id).first()
        if not row:
            return False
        row.status = status
        # NOTE: table/model currently doesn't have 'observations'. If added later, map it here.
        self._db.commit()
        return True

    @staticmethod
    def _to_domain(row: ActivityORM) -> ActivityDomain:
        return ActivityDomain(
            id=row.id,
            student_id=row.student_id,
            agreement_id=row.agreement_id,
            description=row.description,
            entry_photo_path=row.entry_photo_path,
            exit_photo_path=row.exit_photo_path,
            status=row.status,
            created_at=row.created_at,
        )
