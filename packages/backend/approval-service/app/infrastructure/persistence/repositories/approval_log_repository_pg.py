from typing import Optional
from sqlalchemy.orm import Session
from app.domain.ports.approval_log_repository import ApprovalLogRepository
from app.infrastructure.persistence.models import ApprovalLog

class ApprovalLogRepositoryPostgres(ApprovalLogRepository):
    def __init__(self, db: Session):
        self._db = db

    def create(self, activity_id: int, coordinator_id: int, action: str, observations: str) -> ApprovalLog:
        log = ApprovalLog(
            activity_id=activity_id,
            coordinator_id=coordinator_id,
            action=action,
            observations=observations,
        )
        self._db.add(log)
        self._db.commit()
        self._db.refresh(log)
        return log

    def get_by_id(self, log_id: int) -> Optional[ApprovalLog]:
        return self._db.query(ApprovalLog).filter(ApprovalLog.id == log_id).first()
