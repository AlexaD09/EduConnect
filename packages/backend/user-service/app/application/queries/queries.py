from __future__ import annotations
from fastapi import HTTPException
from app.domain.ports.repositories import StudentRepositoryPort, AgreementRepositoryPort, UserRepositoryPort

class GetStudentDetailsUseCase:
    def __init__(self, students: StudentRepositoryPort, users: UserRepositoryPort):
        self.students = students
        self.users = users

    def execute(self, student_id: int) -> dict:
        student = self.students.get_by_id(student_id)
        if not student:
            raise HTTPException(status_code=404, detail="Student not found")
        user = self.users.get_by_username(f"student_{student_id}")  # fallback search
        # better: query by student_id using repo; keep compatibility with existing behavior
        return {
            "id": student.id,
            "full_name": student.full_name,
            "id_number": student.id_number,
            "city": student.city,
            "career": student.career,
            "username": user.username if user else f"student_{student_id}",
        }

class GetStudentByUsernameUseCase:
    def __init__(self, students: StudentRepositoryPort):
        self.students = students

    def execute(self, username: str) -> dict:
        student = self.students.get_by_username(username)
        if not student:
            raise HTTPException(status_code=404, detail="Student not found")
        return {
            "id": student.id,
            "full_name": student.full_name,
            "id_number": student.id_number,
            "city": student.city,
            "career": student.career,
        }

class ListAgreementsUseCase:
    def __init__(self, agreements: AgreementRepositoryPort):
        self.agreements = agreements

    def execute(self):
        return self.agreements.list_all()

class GetAgreementUseCase:
    def __init__(self, agreements: AgreementRepositoryPort):
        self.agreements = agreements

    def execute(self, agreement_id: int):
        agreement = self.agreements.get_by_id(agreement_id)
        if not agreement:
            raise HTTPException(status_code=404, detail="Agreement not found")
        return agreement

class GetCoordinatorByUsernameUseCase:
    def __init__(self, users: UserRepositoryPort):
        self.users = users

    def execute(self, username: str):
        user = self.users.get_by_username(username)
        if not user or user.role_id != 3:
            raise HTTPException(status_code=404, detail="Coordinator not found")
        return {"id": user.id, "username": user.username, "agreement_id": user.agreement_id, "full_name": user.username}
