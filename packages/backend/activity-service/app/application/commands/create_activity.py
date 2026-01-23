from __future__ import annotations
import uuid
from typing import BinaryIO

from app.domain.ports.activity_repository import ActivityRepository
from app.domain.ports.assignment_gateway import AssignmentGateway
from app.domain.ports.storage_port import StoragePort
from app.domain.models.activity import Activity

class CreateActivityCommand:
    def __init__(
        self,
        activity_repo: ActivityRepository,
        assignment_gateway: AssignmentGateway,
        storage: StoragePort,
    ):
        self._activity_repo = activity_repo
        self._assignment_gateway = assignment_gateway
        self._storage = storage

    def execute(
        self,
        student_id: int,
        description: str,
        entry_photo: BinaryIO,
        exit_photo: BinaryIO,
    ) -> Activity:
        assignment = self._assignment_gateway.get_assignment(student_id)
        if not assignment.get("has_assignment"):
            raise ValueError("Student must have an active assignment")

        entry_filename = f"entry_{uuid.uuid4().hex}.jpg"
        exit_filename = f"exit_{uuid.uuid4().hex}.jpg"

        entry_path = self._storage.save(entry_photo, entry_filename)
        exit_path = self._storage.save(exit_photo, exit_filename)

        return self._activity_repo.create(
            student_id=student_id,
            agreement_id=int(assignment["agreement_id"]),
            description=description,
            entry_photo_path=entry_path,
            exit_photo_path=exit_path,
        )
