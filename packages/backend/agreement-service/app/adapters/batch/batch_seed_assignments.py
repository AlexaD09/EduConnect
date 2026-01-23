import os

from app.infrastructure.persistence.database import SessionLocal
from app.infrastructure.persistence.repositories.assignment_repository_pg import AssignmentRepositoryPostgres
from app.infrastructure.persistence.repositories.tutor_repository_pg import TutorRepositoryPostgres
from app.infrastructure.clients.user_service_client import UserServiceClient

from app.application.commands.assign_resources import AssignResourcesUseCase
from app.application.queries.get_assignment import GetAssignmentUseCase


def env_int(name: str, default: int) -> int:
    v = os.getenv(name)
    return int(v) if v and v.isdigit() else default


def seed_assignments(student_from: int, student_to: int) -> None:
    db = SessionLocal()
    try:
        assignment_repo = AssignmentRepositoryPostgres(db)
        tutor_repo = TutorRepositoryPostgres(db)
        user_client = UserServiceClient()

        get_uc = GetAssignmentUseCase(assignment_repo)
        assign_uc = AssignResourcesUseCase(assignment_repo, tutor_repo, user_client)

        created = 0
        for student_id in range(student_from, student_to + 1):
            current = get_uc.execute(student_id)
            if current.get("has_assignment"):
                continue
            try:
                assign_uc.execute(student_id)
                created += 1
            except Exception:
                continue

        print(f"✅ Assignments created: {created}")
    finally:
        db.close()


if __name__ == "__main__":
    start = env_int("SEED_STUDENT_FROM", 1)
    end = env_int("SEED_STUDENT_TO", 50)
    seed_assignments(start, end)
