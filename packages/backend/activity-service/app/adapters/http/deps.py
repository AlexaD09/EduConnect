from __future__ import annotations
from fastapi import Depends
from sqlalchemy.orm import Session

from app.infrastructure.persistence.database import SessionLocal, Base, engine
from app.infrastructure.persistence.repositories.activity_repository_pg import ActivityRepositoryPostgres
from app.infrastructure.clients.agreement_client import AgreementServiceAssignmentGateway
from app.infrastructure.storage.local_storage import LocalStorage

# Create tables at startup (same behavior as original)
Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_activity_repo(db: Session = Depends(get_db)):
    return ActivityRepositoryPostgres(db)

def get_assignment_gateway():
    return AgreementServiceAssignmentGateway()

def get_storage():
    return LocalStorage()
