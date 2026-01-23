 

from sqlalchemy.orm import Session
from app.infrastructure.clients.activity_client import ActivityServiceClient
from app.infrastructure.persistence.repositories.approval_log_repository_pg import ApprovalLogRepositoryPostgres

def update_activity_status(activity_id: int, new_status: str, db: Session):
    
    ActivityServiceClient().update_activity_status(activity_id, new_status)
    return True

def create_approval_log(activity_id: int, coordinator_id: int, action: str, observations: str, db: Session):
    
    repo = ApprovalLogRepositoryPostgres(db)
    return repo.create(activity_id=activity_id, coordinator_id=coordinator_id, action=action, observations=observations)
