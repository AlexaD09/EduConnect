from __future__ import annotations
from abc import ABC, abstractmethod
from typing import Optional, List, Protocol, Dict, Any

class AssignmentRepository(ABC):
    @abstractmethod
    def get_by_student_id(self, student_id: int) -> Optional[dict]:
        ...

    @abstractmethod
    def create(self, student_id: int, agreement_id: int, tutor_id: int) -> dict:
        ...

    @abstractmethod
    def list_by_agreement_id(self, agreement_id: int) -> List[dict]:
        ...
