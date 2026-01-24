from __future__ import annotations
from abc import ABC, abstractmethod
from typing import Dict, Any

class AssignmentGateway(ABC):
    @abstractmethod
    def get_assignment(self, student_id: int) -> Dict[str, Any]:
        """Return JSON like: {has_assignment: bool, agreement_id: int, ...}."""
        raise NotImplementedError
