# backend/activity-service/services/activity_service.py
from sqlalchemy.orm import Session
from models.activity import Activity
from api_clients.agreement_service_client import get_assignment
import os

UPLOAD_DIR = "/app/storage"

def create_activity(db: Session, student_id: int, description: str, entry_photo_path: str, exit_photo_path: str):
    
    assignment = get_assignment(student_id)
    if not assignment.get("has_assignment"):
        raise ValueError("Student must have an active assignment")
    
    
    activity = Activity(
        student_id=student_id,
        agreement_id=assignment["agreement_id"],
        description=description,
        entry_photo_path=entry_photo_path,
        exit_photo_path=exit_photo_path
    )
    db.add(activity)
    db.commit()
    db.refresh(activity)
    return activity