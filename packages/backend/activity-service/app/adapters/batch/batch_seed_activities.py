import os
from io import BytesIO

from app.infrastructure.persistence.database import SessionLocal
from app.infrastructure.persistence.repositories.activity_repository_pg import ActivityRepositoryPostgres
from app.infrastructure.clients.agreement_client import AgreementServiceAssignmentGateway
from app.infrastructure.storage.local_storage import LocalStorage

from app.application.commands.create_activity import CreateActivityCommand


def env_int(name: str, default: int) -> int:
    v = os.getenv(name)
    return int(v) if v and v.isdigit() else default


def seed_activities(student_from: int, student_to: int, per_student: int) -> None:
    db = SessionLocal()
    try:
        repo = ActivityRepositoryPostgres(db)
        gateway = AgreementServiceAssignmentGateway()
        storage = LocalStorage()

        cmd = CreateActivityCommand(repo, gateway, storage)

        dummy_jpg = b"\xff\xd8\xff\xe0" + b"0" * 2048 + b"\xff\xd9"

        created = 0
        for student_id in range(student_from, student_to + 1):
            for i in range(per_student):
                try:
                    cmd.execute(
                        student_id=student_id,
                        description=f"Seeded activity {i+1} for student {student_id}",
                        entry_photo=BytesIO(dummy_jpg),
                        exit_photo=BytesIO(dummy_jpg),
                    )
                    created += 1
                except Exception:
                    break

        print(f"✅ Activities created: {created}")
    finally:
        db.close()


if __name__ == "__main__":
    start = env_int("SEED_STUDENT_FROM", 1)
    end = env_int("SEED_STUDENT_TO", 50)
    per = env_int("SEED_ACTIVITIES_PER_STUDENT", 2)
    seed_activities(start, end, per)
