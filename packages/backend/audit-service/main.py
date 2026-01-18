from fastapi import FastAPI, HTTPException, Depends
from sqlalchemy.orm import Session
from datetime import datetime
import os

app = FastAPI(title="Audit Service")

# Database setup
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:postgres@audit-db:5432/bd_audit")

# Import local modules
from database import SessionLocal, engine
from models import Base, AuditLog

# Create tables
Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/audit/log")
def log_audit_event(
    user_id: str,
    action: str,
    resource: str,
    details: str = None,
    db: Session = Depends(get_db)
):
    """Log an audit event"""
    try:
        audit_log = AuditLog(
            user_id=user_id,
            action=action,
            resource=resource,
            details=details
        )
        db.add(audit_log)
        db.commit()
        return {"message": "Audit log created successfully"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/audit/user/{user_id}")
def get_user_audit_logs(user_id: str, db: Session = Depends(get_db)):
    """Get all audit logs for a specific user"""
    logs = db.query(AuditLog).filter(AuditLog.user_id == user_id).order_by(AuditLog.timestamp.desc()).all()
    return [
        {
            "id": log.id,
            "timestamp": log.timestamp.isoformat(),
            "user_id": log.user_id,
            "action": log.action,
            "resource": log.resource,
            "details": log.details
        }
        for log in logs
    ]

@app.get("/audit/action/{action}")
def get_audit_logs_by_action(action: str, db: Session = Depends(get_db)):
    """Get all audit logs for a specific action"""
    logs = db.query(AuditLog).filter(AuditLog.action == action).order_by(AuditLog.timestamp.desc()).all()
    return [
        {
            "id": log.id,
            "timestamp": log.timestamp.isoformat(),
            "user_id": log.user_id,
            "action": log.action,
            "resource": log.resource,
            "details": log.details
        }
        for log in logs
    ]