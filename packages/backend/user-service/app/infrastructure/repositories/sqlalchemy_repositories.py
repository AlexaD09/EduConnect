from __future__ import annotations
from typing import Optional, List
from sqlalchemy.orm import Session

from app.domain.ports.repositories import (
    UserRepositoryPort, RoleRepositoryPort, StudentRepositoryPort, AgreementRepositoryPort
)
from app.infrastructure.db.models import User, Role, Student, Agreement

class SqlAlchemyUserRepository(UserRepositoryPort):
    def __init__(self, db: Session):
        self.db = db

    def get_by_username(self, username: str) -> Optional[User]:
        return self.db.query(User).filter(User.username == username).first()

    def get_by_email(self, email: str) -> Optional[User]:
        return self.db.query(User).filter(User.email == email).first()

    def create_user(self, *, email: str, username: str, password_hash: str, role_id: int,
                    student_id: Optional[int] = None, agreement_id: Optional[int] = None) -> User:
        user = User(
            email=email,
            username=username,
            password=password_hash,
            role_id=role_id,
            student_id=student_id,
            agreement_id=agreement_id
        )
        self.db.add(user)
        self.db.commit()
        self.db.refresh(user)
        return user

class SqlAlchemyRoleRepository(RoleRepositoryPort):
    def __init__(self, db: Session):
        self.db = db

    def get_by_name(self, name: str) -> Optional[Role]:
        return self.db.query(Role).filter_by(name=name).first()

    def create(self, name: str) -> Role:
        role = Role(name=name)
        self.db.add(role)
        self.db.commit()
        self.db.refresh(role)
        return role

class SqlAlchemyStudentRepository(StudentRepositoryPort):
    def __init__(self, db: Session):
        self.db = db

    def get_by_id(self, student_id: int) -> Optional[Student]:
        return self.db.query(Student).filter(Student.id == student_id).first()

    def get_by_username(self, username: str) -> Optional[Student]:
        user = self.db.query(User).filter(User.username == username).first()
        if not user or not user.student_id:
            return None
        return self.get_by_id(user.student_id)

class SqlAlchemyAgreementRepository(AgreementRepositoryPort):
    def __init__(self, db: Session):
        self.db = db

    def list_all(self) -> List[Agreement]:
        return self.db.query(Agreement).all()

    def get_by_id(self, agreement_id: int) -> Optional[Agreement]:
        return self.db.query(Agreement).filter(Agreement.id == agreement_id).first()
