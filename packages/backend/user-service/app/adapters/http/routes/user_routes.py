from __future__ import annotations
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.adapters.http.deps import get_db, build_repos, get_hasher, get_jwt_service
from app.application.dtos.schemas import UserLogin
from app.application.commands.login import LoginUseCase
from app.application.queries.queries import (
    GetStudentDetailsUseCase, ListAgreementsUseCase, GetStudentByUsernameUseCase, GetAgreementUseCase, GetCoordinatorByUsernameUseCase
)

router = APIRouter()

@router.post("/login")
def login(payload: UserLogin, db: Session = Depends(get_db)):
    repos = build_repos(db)
    uc = LoginUseCase(repos["users"], get_hasher(), get_jwt_service())
    return uc.execute(payload.username, payload.password)

@router.get("/students/{student_id}")
def get_student_details(student_id: int, db: Session = Depends(get_db)):
    repos = build_repos(db)
    uc = GetStudentDetailsUseCase(repos["students"], repos["users"])
    return uc.execute(student_id)

@router.get("/agreements")
def list_agreements(db: Session = Depends(get_db)):
    repos = build_repos(db)
    uc = ListAgreementsUseCase(repos["agreements"])
    return uc.execute()

@router.get("/students/by-username/{username}")
def get_student_by_username(username: str, db: Session = Depends(get_db)):
    repos = build_repos(db)
    uc = GetStudentByUsernameUseCase(repos["students"])
    return uc.execute(username)

@router.get("/agreements/{agreement_id}")
def get_agreement_by_id(agreement_id: int, db: Session = Depends(get_db)):
    repos = build_repos(db)
    uc = GetAgreementUseCase(repos["agreements"])
    return uc.execute(agreement_id)

@router.get("/coordinators/by-username/{username}")
def get_coordinator_by_username(username: str, db: Session = Depends(get_db)):
    repos = build_repos(db)
    uc = GetCoordinatorByUsernameUseCase(repos["users"])
    return uc.execute(username)
