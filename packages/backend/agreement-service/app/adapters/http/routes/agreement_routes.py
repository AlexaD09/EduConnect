from __future__ import annotations
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.infrastructure.persistence.database import SessionLocal
from app.infrastructure.persistence.repositories.assignment_repository_pg import AssignmentRepositoryPostgres
from app.infrastructure.persistence.repositories.tutor_repository_pg import TutorRepositoryPostgres
from app.infrastructure.clients.user_service_client import UserServiceClient

from app.application.commands.assign_resources import AssignResourcesUseCase
from app.application.queries.get_assignment import GetAssignmentUseCase
from app.application.queries.get_tutor import GetTutorUseCase
from app.application.queries.get_assignments_by_coordinator import GetAssignmentsByCoordinatorUseCase

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/assignment/{student_id}")
def get_assignment(student_id: int, db: Session = Depends(get_db)):
    assignment_repo = AssignmentRepositoryPostgres(db)
    uc = GetAssignmentUseCase(assignment_repo)
    return uc.execute(student_id)

@router.post("/assign/{student_id}")
def assign_resources(student_id: int, db: Session = Depends(get_db)):
    assignment_repo = AssignmentRepositoryPostgres(db)
    tutor_repo = TutorRepositoryPostgres(db)
    user_client = UserServiceClient()

    uc = AssignResourcesUseCase(assignment_repo, tutor_repo, user_client)
    try:
        return uc.execute(student_id)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/tutors/{tutor_id}")
def get_tutor_details(tutor_id: int, db: Session = Depends(get_db)):
    tutor_repo = TutorRepositoryPostgres(db)
    uc = GetTutorUseCase(tutor_repo)
    try:
        return uc.execute(tutor_id)
    except KeyError:
        raise HTTPException(status_code=404, detail="Tutor not found")

@router.get("/assignments/coordinator/{coordinator_id}")
def get_assignments_by_coordinator(coordinator_id: int, db: Session = Depends(get_db)):
    assignment_repo = AssignmentRepositoryPostgres(db)
    user_client = UserServiceClient()
    uc = GetAssignmentsByCoordinatorUseCase(assignment_repo, user_client)
    try:
        return uc.execute(coordinator_id)
    except Exception as e:
        # Mantener comportamiento original: si falla externo, devolver []
        return []
