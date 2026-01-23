from __future__ import annotations
import os
from typing import Generator
from sqlalchemy.orm import Session

from app.infrastructure.db.session import SessionLocal
from app.infrastructure.repositories.sqlalchemy_repositories import (
    SqlAlchemyUserRepository, SqlAlchemyRoleRepository, SqlAlchemyStudentRepository, SqlAlchemyAgreementRepository
)
from app.infrastructure.security.password_hasher import PasswordHasher
from app.infrastructure.security.jwt_service import JwtService

def get_db() -> Generator[Session, None, None]:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def build_repos(db: Session):
    return {
        "users": SqlAlchemyUserRepository(db),
        "roles": SqlAlchemyRoleRepository(db),
        "students": SqlAlchemyStudentRepository(db),
        "agreements": SqlAlchemyAgreementRepository(db),
    }

def get_hasher() -> PasswordHasher:
    return PasswordHasher()

def get_jwt_service() -> JwtService:
    secret = os.getenv("JWT_SECRET_KEY", "CHANGE_ME_IN_PROD")
    expires = int(os.getenv("JWT_EXPIRES_MIN", "60"))
    return JwtService(secret_key=secret, expires_minutes=expires)
