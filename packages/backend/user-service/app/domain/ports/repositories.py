from __future__ import annotations
from typing import Protocol, Optional, List, Dict, Any

class UserReadModel(Protocol):
    id: int
    email: str
    username: str
    role_id: int
    student_id: Optional[int]
    agreement_id: Optional[int]

class StudentReadModel(Protocol):
    id: int
    full_name: str
    id_number: str
    city: str
    career: str

class AgreementReadModel(Protocol):
    id: int
    name: str
    institution: str
    city: str
    coordinator_name: str
    coordinator_id_number: str

class UserRepositoryPort(Protocol):
    def get_by_username(self, username: str) -> Optional[UserReadModel]: ...
    def get_by_email(self, email: str) -> Optional[UserReadModel]: ...
    def create_user(self, *, email: str, username: str, password_hash: str, role_id: int,
                    student_id: Optional[int] = None, agreement_id: Optional[int] = None) -> UserReadModel: ...

class RoleRepositoryPort(Protocol):
    def get_by_name(self, name: str): ...
    def create(self, name: str): ...

class StudentRepositoryPort(Protocol):
    def get_by_id(self, student_id: int) -> Optional[StudentReadModel]: ...
    def get_by_username(self, username: str) -> Optional[StudentReadModel]: ...

class AgreementRepositoryPort(Protocol):
    def list_all(self) -> List[AgreementReadModel]: ...
    def get_by_id(self, agreement_id: int) -> Optional[AgreementReadModel]: ...
