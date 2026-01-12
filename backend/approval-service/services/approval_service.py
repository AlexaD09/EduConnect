import requests
from sqlalchemy.orm import Session
from models.approval import ApprovalLog

ACTIVITY_SERVICE_URL = "http://activity-service:8000"

def update_activity_status(activity_id: int, new_status: str, db: Session):
    """Update activity status in activity-service"""
    try:
        response = requests.patch(
            f"{ACTIVITY_SERVICE_URL}/activities/{activity_id}/status",
            json={"status": new_status}
        )
        response.raise_for_status()
        return True
    except Exception as e:
        raise Exception(f"Failed to update activity status: {str(e)}")

def create_approval_log(activity_id: int, coordinator_id: int, action: str, observations: str, db: Session):
    """Create approval log entry"""
    log = ApprovalLog(
        activity_id=activity_id,
        coordinator_id=coordinator_id,
        action=action,
        observations=observations
    )
    db.add(log)
    db.commit()
    return log