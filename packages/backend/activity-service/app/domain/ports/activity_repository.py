from __future__ import annotations
from abc import ABC, abstractmethod
from typing import List, Optional
from app.domain.models.activity import Activity

class ActivityRepository(ABC):
    @abstractmethod
    def create(
        self,
        student_id: int,
        agreement_id: int,
        description: str,
        entry_photo_path: str,
        exit_photo_path: str,
    ) -> Activity:
        raise NotImplementedError

    @abstractmethod
    def list_by_student(self, student_id: int) -> List[Activity]:
        raise NotImplementedError

    @abstractmethod
    def list_pending_by_agreement(self, agreement_id: int) -> List[Activity]:
        raise NotImplementedError

    @abstractmethod
    def get_by_id(self, activity_id: int) -> Optional[Activity]:
        raise NotImplementedError

    @abstractmethod
    def update_status(
        self,
        activity_id: int,
        status: str,
        observations: Optional[str] = None,
    ) -> bool:
        """Returns True if updated, False if activity does not exist."""
        raise NotImplementedError
