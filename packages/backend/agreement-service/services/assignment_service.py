from sqlalchemy.orm import Session
from app.infrastructure.persistence.repositories.assignment_repository_pg import AssignmentRepositoryPostgres
from app.infrastructure.persistence.repositories.tutor_repository_pg import TutorRepositoryPostgres
from app.infrastructure.clients.user_service_client import UserServiceClient
from app.application.commands.assign_resources import AssignResourcesUseCase

# Backwards compatible function for existing imports/tests
def assign_agreement_and_tutor(db: Session, student_id: int):
    assignment_repo = AssignmentRepositoryPostgres(db)
    tutor_repo = TutorRepositoryPostgres(db)
    user_client = UserServiceClient()
    return AssignResourcesUseCase(assignment_repo, tutor_repo, user_client).execute(student_id)
